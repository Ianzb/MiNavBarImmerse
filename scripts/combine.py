from rule import *
save_file("module/immerse_rules.json", importFromOS33("backup/backup_os33_260410.json").updateFromRule(importFromOS33("module/immerse_rules.json")).toData("33"))
