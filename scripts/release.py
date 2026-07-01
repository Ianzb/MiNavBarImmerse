import os
from datetime import datetime, timezone, timedelta
from rule import *

# 获取 UTC+8 今天的日期，格式为 YYMMDD
tz_utc8 = timezone(timedelta(hours=8))
today = datetime.now(tz_utc8).strftime("%y%m%d")

merge_path = "rules/merge.json"

# 如果 merge.json 非空，先合并本地规则
if os.path.exists(merge_path) and os.path.getsize(merge_path) > 0:
    data = importFromOS33("rules/immerse_rules.json")
    data.updateFromRule(importFromOS33(merge_path))
    save_file("rules/immerse_rules.json", data.toData("33"))
    save_file(merge_path, "")  # 合并后清空

# 读取规则并更新 dataVersion
data = importFromOS33("rules/immerse_rules.json")
result = json.loads(data.toData("dict"))
result["dataVersion"] = today

save_file("rules/immerse_rules.json", json.dumps(result, indent=2, ensure_ascii=False))
