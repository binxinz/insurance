def path_name(name):
    global find_name
    new_name = ["\\年金保险\\养老年金保险", "\\健康保险\\疾病保险", "\\健康保险\\医疗保险", "\\健康保险\\护理保险",
                "\\健康保险\\失能收入损失保险", "\\人寿保险\\两全保险", "\\人寿保险\\定期寿险", "\\人寿保险\\终身寿险",
                "\\人寿保险", "\\意外伤害保险", "\\年金保险", "\\人寿保险", "\\健康保险"]
    index = 0
    while (index < len(find_name)):
        if str(name).find(str(find_name[index]['name'])) != -1:
            break
        else:
            index = index + 1

    if index >= len(find_name):
        return "\\其他类型产品"
    else:
        return new_name[index]
    
    
    
