﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЕстьОтбор = Параметры.Отбор.Свойство("Номенклатура");
	МаркируемаяПродукция = Ложь;
	
	Если ЕстьОтбор Тогда
		Номенклатура = Параметры.Отбор.Номенклатура;
		МаркируемаяПродукция = ИнтеграцияИСМПБП.МаркируемаяПродукция(Номенклатура);
	КонецЕсли;
	
	Элементы.Номенклатура.Видимость = НЕ ЕстьОтбор;
	Элементы.ДекорацияВидыУпаковокПоGTIN.Видимость = ЕстьОтбор И МаркируемаяПродукция;
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаОткрытьФормуНастройкиВидовУпаковокПоGTINИСМП(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Номенклатура) Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияИСМПКлиент.ОткрытьФормуНастройкиВидовУпаковокПоНоменклатуре(ЭтотОбъект, Номенклатура);
	
КонецПроцедуры
