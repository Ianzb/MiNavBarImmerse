from rule import *
save_file("rules/immerse_rules.json", importFromOS33("rules/immerse_rules.json").updateFromRule(importFromOS33("rules/merge.json")).toData("33"))
