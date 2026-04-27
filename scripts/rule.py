from utils import *


class ActivityRule:
    def __init__(self, name: str, mode: int = -1, color: int | str = None, sf_sampling_mode: int = 0, dialogMode: int = 1, popupMode: int = 1, appNavColorDisabled: int = 0, viewRules: list = None, **args):
        self.name = name
        self.mode = int(mode)
        if isinstance(color, str) and is_number(color):
            color = int(color)
        self.color = argb_int_to_rgba(color) if isinstance(color, int) and color != 1 else color
        self.sf_sampling_mode = sf_sampling_mode
        self.dialogMode = dialogMode
        self.popupMode = popupMode
        self.appNavColorDisabled = appNavColorDisabled
        self.viewRules = viewRules

    def toData(self, mode: str = "dict"):
        color = rgba_to_argb_int(self.color) if isinstance(self.color, str) else self.color
        if mode in ["dict", "33"]:
            result = {"mode": self.mode, "color": color}
            if self.sf_sampling_mode is not None:
                result["sf_sampling_mode"] = self.sf_sampling_mode
            if self.dialogMode is not None:
                result["dialogMode"] = self.dialogMode
            if self.popupMode is not None:
                result["popupMode"] = self.popupMode
            if self.appNavColorDisabled is not None:
                result["appNavColorDisabled"] = self.appNavColorDisabled
            if self.viewRules:
                result["viewRules"] = self.viewRules
            return result
        elif mode == "30":
            result = {"mode": self.mode, "color": color}
            if self.viewRules:
                result["viewRules"] = self.viewRules
            return result
        elif mode == "22":
            if self.mode == 1:
                return ":".join([str(self.name), str(self.mode), str(color)])
            else:
                return ":".join([str(self.name), str(self.mode)])

    @classmethod
    def fromData(cls, mode: str, name: str, data):
        if mode in ["dict", "33", "30"]:
            return cls(name=name, **data)
        elif mode == "22":
            data = data.split(":")
            return cls(name=data[0], mode=data[1], color=data[2] if len(data) == 3 else None)

    def updateFromDict(self, data):
        if "mode" in data:
            self.mode = data["mode"]
        if "color" in data:
            self.color = data["color"]
        if "sf_sampling_mode" in data:
            self.sf_sampling_mode = data["sf_sampling_mode"]
        if "dialogMode" in data:
            self.dialogMode = data["dialogMode"]
        if "popupMode" in data:
            self.popupMode = data["popupMode"]
        if "appNavColorDisabled" in data:
            self.appNavColorDisabled = data["appNavColorDisabled"]
        if "viewRules" in data:
            self.viewRules = data["viewRules"]
        return self

    def updateFromRule(self, rule):
        self.updateFromDict(rule.toData())
        return self


class AppRule:
    def __init__(self, mode: str, package_name: str, name: str = "", enable: bool = True, disableVersionCode: int = None, activityRules: dict | str = None, **args):
        self.package_name = package_name
        self.name = name
        self.enable = enable
        self.disableVersionCode = disableVersionCode

        if mode == "22":
            self.activityRules = {data[0]: ActivityRule.fromData(mode, data.split(":")[0], data) for data in activityRules.split(",")} if activityRules else {}
        else:
            self.activityRules = {name: ActivityRule.fromData(mode, name, data) for name, data in activityRules.items()} if activityRules else {}

    def toData(self, mode: str = "dict"):
        if mode in ["dict", "33", "30"]:
            result = {"name": self.name, "enable": self.enable}
            if self.disableVersionCode is not None:
                result["disableVersionCode"] = self.disableVersionCode
            sorted_activity_rules = sorted(self.activityRules.items(), key=lambda x: x[0])
            result["activityRules"] = {name: rule.toData(mode) for name, rule in sorted_activity_rules}
            return result
        elif mode == "22":
            sorted_activities = sorted(self.activityRules.values(), key=lambda x: x.name)
            activity_rules_str = ",".join([i.toData(mode) for i in sorted_activities]) if sorted_activities else ""
            result = {"@name": self.package_name, "@enable": self.enable, "@activityRule": activity_rules_str}
            return result

    @classmethod
    def fromData(cls, mode: str, package_name: str, data):
        if mode == "22":
            return cls(mode=mode, package_name=package_name, name="", enable=data.get("@enable", False), activityRules=data.get("@activityRule", ""))
        if mode == "33":
            data["enable"] = data.get("enable", False) or data.get("enable31", False)
        return cls(mode=mode, package_name=package_name, **data)

    def updateFromDict(self, data):
        if not self.name and data.get("name"):
            self.name = data.get("name")
        if "activityRules" in data:
            for name, rule in data["activityRules"].items():
                if name in self.activityRules:
                    self.activityRules[name].updateFromDict(rule)
                else:
                    self.activityRules[name] = ActivityRule.fromData("dict", name, rule)
        return self

    def updateFromRule(self, rule):
        self.updateFromDict(rule.toData())
        return self


class Rule:
    def __init__(self, mode: str, NBIRules: dict | list = None, **args):
        if mode in "22":
            self.NBIRules = {data["@name"]: AppRule.fromData(mode, data["@name"], data) for data in NBIRules} if NBIRules else {}
        else:
            self.NBIRules = {package_name: AppRule.fromData(mode, package_name, data) for package_name, data in NBIRules.items()} if NBIRules else {}

    def toData(self, mode: str = "dict"):
        if mode in "dict":
            sorted_rules = sorted(self.NBIRules.items(), key=lambda x: x[0])
            result = {
                "dataVersion": "999999",
                "modules": "navigation_bar_immersive_application_config_new",
                "modifyApps": "modifyApps",
            }
            if self.NBIRules:
                result["NBIRules"] = {package_name: rule.toData(mode) for package_name, rule in sorted_rules}
            return result
        elif mode in ["33", "30"]:
            sorted_rules = sorted(self.NBIRules.items(), key=lambda x: x[0])
            result = {
                "dataVersion": "999999",
                "modules": "navigation_bar_immersive_application_config_new",
                "modifyApps": "modifyApps",
            }
            if self.NBIRules:
                result["NBIRules"] = {package_name: rule.toData(mode) for package_name, rule in sorted_rules}
            return json.dumps(result, indent=2, ensure_ascii=False)
        elif mode == "22":
            sorted_rules = sorted(self.NBIRules.values(), key=lambda x: x.package_name)
            result = {
                "NBIRules": {
                    '@xmlns:xsi': 'http://www.w3.org/2001/XMLSchema-instance',
                    "package": [i.toData(mode) for i in sorted_rules]
                }
            }
            result = xmltodict.unparse(result, pretty=True, encoding="utf-8", short_empty_elements=True)
            return result

    @classmethod
    def fromData(cls, mode: str, data):
        if mode in ["dict", "33", "30"]:
            return cls(mode=mode, **data)
        elif mode == "22":
            return cls(mode=mode, NBIRules=data.get("NBIRules", {}).get("package", []))

    def updateFromDict(self, data):
        if "NBIRules" in data:
            for package_name, rule in data["NBIRules"].items():
                if package_name in self.NBIRules:
                    self.NBIRules[package_name].updateFromDict(rule)
                else:
                    self.NBIRules[package_name] = AppRule.fromData("dict", package_name, rule)
        return self

    def updateFromRule(self, rule):
        self.updateFromDict(rule.toData())
        return self


def importFromOS33(path: str):
    return Rule.fromData("33", read_json_file(path))


def importFromOS30(path: str):
    return Rule.fromData("30", read_json_file(path))


def importFromOS22(path: str):
    return Rule.fromData("22", read_xml_file(path))
