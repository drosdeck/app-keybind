#include <linux/types.h>
#include <linux/module.h>
#include <linux/keyboard.h>
#include <linux/input.h>
#include <linux/kernel.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>

static char str[64];

static int hello_proc_show(struct seq_file *m,void *v)
{
  seq_printf(m,str);
  return 0;
}


static int hello_proc_open(struct inode *inode,struct file *file)
{
     return single_open(file,hello_proc_show,NULL);

}




int kbd_notifier(struct notifier_block *nblock,unsigned long code,void* _param)
{
   
    struct keyboard_notifier_param *param  = _param;
     
    snprintf(str,64,"type:%ld  value:%d actions: %s",code,param->value,(param->down ? "down" : "up"));	


   return NOTIFY_OK;
}


struct notifier_block nb = 
{
   .notifier_call = kbd_notifier

};

static const struct file_operations hello_proc_fops =
{
    .owner = THIS_MODULE,
    .open = hello_proc_open,
    .read = seq_read,
    .llseek = seq_lseek,
    .release = single_release, 
};

static int __init  func_init(void)
{
   
   printk(KERN_INFO "get_key init\n");
   proc_create("get_key",0,NULL,&hello_proc_fops);
   register_keyboard_notifier(&nb);
   return 0;
}

static void __exit func_exit(void)
{

    remove_proc_entry("get_key",NULL);
    unregister_keyboard_notifier(&nb);
    printk(KERN_INFO "get_key exited\n");
}

MODULE_LICENSE("GPL");
module_init(func_init);
module_exit(func_exit);
