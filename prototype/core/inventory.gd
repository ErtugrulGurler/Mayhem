class_name PhysicalInventory
extends RefCounted
static func total(stock: Dictionary) -> int:
	var amount := 0
	for n in stock.values():
		amount += int(n)
	return amount
static func has(stock: Dictionary, cost: Dictionary) -> bool:
	for key in cost:
		if int(stock.get(key,0)) < int(cost[key]):
			return false
	return true
static func remove(stock: Dictionary, cost: Dictionary) -> bool:
	if not has(stock,cost):
		return false
	for key in cost:
		stock[key] -= cost[key]
		if stock[key] == 0:
			stock.erase(key)
	return true
static func add(stock: Dictionary, item: String, amount: int, capacity: int) -> int:
	var accepted := mini(maxi(0,amount), maxi(0, capacity-total(stock)))
	if accepted > 0:
		stock[item] = stock.get(item,0)+accepted
	return accepted
static func transfer(source: Dictionary, target: Dictionary, item: String, amount: int, capacity: int) -> int:
	var accepted := add(target,item,mini(amount,int(source.get(item,0))),capacity)
	if accepted > 0:
		remove(source,{item:accepted})
	return accepted
