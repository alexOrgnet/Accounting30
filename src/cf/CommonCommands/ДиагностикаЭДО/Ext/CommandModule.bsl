﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыВыполненияДиагностики = ДиагностикаЭДОКлиентСервер.НовыеПараметрыВыполненияДиагностики();
	ПараметрыВыполненияДиагностики.ВыполнятьПроверкиСертификатовВВебКлиенте = Истина;
	ДиагностикаЭДОКлиент.ВыполнитьДиагностику(ПараметрыВыполненияДиагностики);
	
КонецПроцедуры

#КонецОбласти