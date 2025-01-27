﻿// @strict-types

#Область СлужебныйПрограммныйИнтерфейс

// Вызывается при ошибке выполнения криптографической операции. В процедуре можно дополнить текст ошибки.
// 
// Параметры:
//  КонтекстДиагностики - Неопределено
//                      - см. ОбработкаНеисправностейБЭДКлиент.НовыйКонтекстДиагностики
//  ПодробноеПредставлениеОшибки - Строка
//  КраткоеПредставлениеОшибки - Строка
Процедура ПриОшибкеВыполненияКриптографическойОперации(КонтекстДиагностики, ПодробноеПредставлениеОшибки, КраткоеПредставлениеОшибки) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами") Тогда
		МодульСинхронизацияЭДОКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль(
			"СинхронизацияЭДОКлиентСервер");
		МодульСинхронизацияЭДОКлиентСервер.ПриОшибкеВыполненияКриптографическойОперации(КонтекстДиагностики,
			ПодробноеПредставлениеОшибки, КраткоеПредставлениеОшибки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

