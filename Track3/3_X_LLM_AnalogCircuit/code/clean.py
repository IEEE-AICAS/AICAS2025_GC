import os
import shutil
import sys

def setup_environment():
    """设置环境变量和工作目录"""
    root_dir = os.path.dirname(os.path.abspath(__file__))
    if root_dir not in sys.path:
        sys.path.insert(0, root_dir)
    os.chdir(root_dir)

def clean_directory(dir_path: str):
    """清空指定目录下的所有内容"""
    if not os.path.exists(dir_path):
        print(f"目录不存在: {dir_path}")
        return
    
    try:
        # 删除目录下的所有内容
        for item in os.listdir(dir_path):
            item_path = os.path.join(dir_path, item)
            try:
                if os.path.isfile(item_path):
                    os.unlink(item_path)
                elif os.path.isdir(item_path):
                    shutil.rmtree(item_path)
                print(f"已删除: {item_path}")
            except Exception as e:
                print(f"删除 {item_path} 时出错: {str(e)}")
        
        print(f"已清空目录: {dir_path}")
    except Exception as e:
        print(f"清空目录 {dir_path} 时出错: {str(e)}")

def main():
    """主函数"""
    # 设置环境
    setup_environment()
    
    # 要清理的目录列表
    directories = ['logs', 'history', 'batch_results']
    
    print("开始清理...")
    for dir_name in directories:
        print(f"\n清理 {dir_name} 目录...")
        clean_directory(dir_name)
    
    print("\n清理完成!")

if __name__ == "__main__":
    main()
