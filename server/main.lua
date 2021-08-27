ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

RegisterServerEvent('esx_blackmoney:checkToken')
AddEventHandler('esx_blackmoney:checkToken', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local tokenQuantity = xPlayer.getInventoryItem('washtoken').count
	local tokenQuantity2 = xPlayer.getInventoryItem('washtoken2').count
	local accountMoney = 0
	accountMoney = xPlayer.getAccount('black_money').money
	
	if accountMoney > 4999 and tokenQuantity2 > 0 then
		TriggerClientEvent('esx_blackmoney:success2', source)
	elseif accountMoney > 999 and tokenQuantity > 0 then
		TriggerClientEvent('esx_blackmoney:success', source)
	else
		notification('You do not have enough tokens or dirty money to use our washer')
	end	

end)

RegisterServerEvent('esx_blackmoney:washMoney')
AddEventHandler('esx_blackmoney:washMoney', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
			xPlayer.removeInventoryItem('washtoken', 1)
			xPlayer.removeAccountMoney('black_money', 1000)
			xPlayer.addMoney(1000)
			notification('You ~g~washed~s~ $1000 ~r~dirty money')

end)

RegisterServerEvent('esx_blackmoney:washMoney2')
AddEventHandler('esx_blackmoney:washMoney2', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
			xPlayer.removeInventoryItem('washtoken2', 1)
			xPlayer.removeAccountMoney('black_money', 5000)
			xPlayer.addMoney(5000)
			notification('You ~g~washed~s~ $5000 ~r~dirty money')

end)

RegisterServerEvent('esx_blackmoney:buyToken')
AddEventHandler('esx_blackmoney:buyToken', function(itemName, price, amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local allprice = amount*price
	if(xPlayer.getMoney() >= allprice) then
		xPlayer.removeMoney(allprice)
		
		xPlayer.addInventoryItem(itemName, amount)
		
		notification("You bought ~g~Tokens")
	else
		notification("You don't have enough ~r~money")
	end		
end)

function notification(text)
	TriggerClientEvent('esx:showNotification', source, text)
end