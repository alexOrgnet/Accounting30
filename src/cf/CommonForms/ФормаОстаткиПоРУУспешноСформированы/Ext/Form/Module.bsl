﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Организация                   = Параметры.Организация;
	Период                        = Параметры.Период;
	ЕстьОбособленныеПодразделения = Параметры.ЕстьОбособленныеПодразделения;
	
	ОстаткиУспешноСформированы = НСтр("ru = 'Остатки успешно сформированы на %1'");
	ОстаткиУспешноСформированы = СтрШаблон(ОстаткиУспешноСформированы, Формат(Период, "ДЛФ=Д"));

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДокументыВводаОстатков(Команда)
	
	ПараметрыДляОткрытияФормы = Новый Структура("Организация, ДоступенОтборПоОрганизации, ВключатьОбособленныеПодразделения",
		ЭтотОбъект.Организация, Истина, ЭтотОбъект.ЕстьОбособленныеПодразделения);
	ОткрытьФорму("ОбщаяФорма.ВводНачальныхОстатковДляВеденияРаздельногоУчетаНДС", ПараметрыДляОткрытияФормы);

КонецПроцедуры

#КонецОбласти

