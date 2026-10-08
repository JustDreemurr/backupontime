function main(config) {
  const entry = "链式-落地";
  const mainGroup = "🚀 手动选择";
  const groups = config["proxy-groups"] || [];

  if (!groups.some(group => group.name === entry)) {
    throw new Error("未找到链式-落地，请先执行 YAML 覆写");
  }

  for (const group of groups) {
    if (group.type !== "select") continue;

    const proxies = group.proxies || [];

    // 接入主策略组，以及原来就能选择主策略组的业务组。
    if (
      group.name !== mainGroup &&
      !proxies.includes(mainGroup)
    ) {
      continue;
    }

    if (!proxies.includes(entry)) {
      group.proxies = [...proxies, entry];
    }
  }

  return config;
}
