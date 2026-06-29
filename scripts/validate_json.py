import sys
import traceback

from rule import *

try:
    importFromOS33("rules/immerse_rules.json").toData("33")
except:
    traceback.print_exc()
    sys.exit(1)
sys.exit(0)
