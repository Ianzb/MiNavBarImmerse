from datetime import datetime, timezone, timedelta
from rule import *

# 获取 UTC+8 今天的日期，格式为 YYMMDD
tz_utc8 = timezone(timedelta(hours=8))
today = datetime.now(tz_utc8).strftime("%y%m%d")

# 读取规则并更新 dataVersion
data = importFromOS33("rules/immerse_rules.json")
result = json.loads(data.toData("dict"))
result["dataVersion"] = today

save_file("rules/immerse_rules.json", json.dumps(result, indent=2, ensure_ascii=False))
