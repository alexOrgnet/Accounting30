﻿&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	АдресВременногоХранилища = Параметры.Адрес;
	Если ЭтоАдресВременногоХранилища(АдресВременногоХранилища) Тогда
		ПереданныеОтчеты = ПолучитьИзВременногоХранилища(Параметры.Адрес);
		Отчеты.Загрузить(ПереданныеОтчеты);
		
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура ОтчетыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.Отчеты.ТекущиеДанные <> Неопределено Тогда 
		Если Поле.Имя = "ОтчетыПредставление" Тогда 
			СтандартнаяОбработка = Ложь;
			ПоказатьЗначение(, Элементы.Отчеты.ТекущиеДанные.Отчет);
			
		ИначеЕсли Поле.Имя = "ОтчетыСостояние" Тогда 
			СтандартнаяОбработка = Ложь;
			КонтекстЭДОКлиент.ПоказатьФормуСтатусовОтправки(Элементы.Отчеты.ТекущиеДанные.Отчет);
			
		ИначеЕсли Поле.Имя = "ОтчетыНаименованиеПротокола" Тогда
			СтандартнаяОбработка = Ложь;
			
			Протокол 	= Элементы.Отчеты.ТекущиеДанные.Протокол;
			ЦиклОбмена 	= Элементы.Отчеты.ТекущиеДанные.ЦиклОбмена;
			
			КонтекстЭДОКлиент.ПоказатьДокументыЦикловОбмена(ЦиклОбмена, Истина, Протокол);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НапомнитьПозжеКоманда(Команда)
	
	ПрограммноеЗакрытие = Истина;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура БольшеНеПоказыватьКоманда(Команда)
	
	НапомнитьПозжеОНекорректныхСтатусахОтправкиПФР(Ложь);
	ПрограммноеЗакрытие = Истина;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НапомнитьПозжеОНекорректныхСтатусахОтправкиПФР(ОтветИлиОтчеты)
	
	ХранилищеОбщихНастроек.Сохранить("ИзменениеСтатусаПФРСоСданоНаСданоЧастично2021_НапомнитьПозжеОтчеты",,
		ОтветИлиОтчеты);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
КонецПроцедуры

#КонецОбласти




