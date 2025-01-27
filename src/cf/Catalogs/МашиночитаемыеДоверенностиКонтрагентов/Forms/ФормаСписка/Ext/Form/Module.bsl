﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЕстьПравоИзменения = Справочники.МашиночитаемыеДоверенностиКонтрагентов.ЕстьПравоИзменения();
	Элементы.ФормаЗагрузитьПерезаполнитьИзФайла.Видимость = ЕстьПравоИзменения;
	
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяДатаСеанса());
	Список.Параметры.УстановитьЗначениеПараметра(
		"БудетОтозвана", МашиночитаемыеДоверенностиКлиентСервер.ЗаголовокБудетОтозвана());
	Список.Параметры.УстановитьЗначениеПараметра("Да", НСтр("ru = 'Да'"));
	Список.Параметры.УстановитьЗначениеПараметра("Нет", НСтр("ru = 'Нет'"));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	МашиночитаемыеДоверенности.ПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Загрузить(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьЗавершение", ЭтотОбъект);
	МашиночитаемыеДоверенностиКлиент.ПолучитьДанныеМЧД(ОписаниеОповещения, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьПерезаполнитьИзФайла(Команда)
	
	ОбработчикЗавершения = Новый ОписаниеОповещения("ЗагрузитьПерезаполнитьИзФайлаЗавершение", ЭтотОбъект);
	
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.ИдентификаторФормы = УникальныйИдентификатор;
	ПараметрыЗагрузки.Диалог.Фильтр = НСтр("ru = 'Архив'") + " (*.zip)|*.zip";
	ПараметрыЗагрузки.Диалог.Заголовок = НСтр("ru = 'Выберите архив с доверенностью и подписью'");
	
	ФайловаяСистемаКлиент.ЗагрузитьФайл(ОбработчикЗавершения, ПараметрыЗагрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьОтозванной(Команда)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СсылкаНаЭлементСправочника = Элементы.Список.ТекущаяСтрока;
	ПараметрыФормы = Новый Структура("Ключ", СсылкаНаЭлементСправочника);	
	ОткрытьФорму("Справочник.МашиночитаемыеДоверенностиКонтрагентов.Форма.ФормаЭлемента", ПараметрыФормы);
	
	ТекстСообщения = НСтр("ru = 'Для изменения пометки отозвана выполните: Еще - Пометить отозванной/Вернуть в работу'");
	ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗагрузитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не ЗначениеЗаполнено(Результат.СсылкаНаДоверенность) Тогда
		Если Результат.Свойство("ТекстОшибки") Тогда
			МашиночитаемыеДоверенностиКлиент.ПоказатьПредупреждениеПриЗагрузкеМЧД(Результат.ТекстОшибки);
		КонецЕсли;
		Возврат;
	КонецЕсли;

	Элементы.Список.Обновить();
	
	ПараметрыФормы = Новый Структура("Ключ, ОбновитьСостояниеПриОткрытии", Результат.СсылкаНаДоверенность, Истина);
	УИДФормы = Новый УникальныйИдентификатор;
	Если ТипЗнч(Результат.СсылкаНаДоверенность) = Тип("СправочникСсылка.МашиночитаемыеДоверенностиОрганизаций") Тогда
		ОткрытьФорму("Справочник.МашиночитаемыеДоверенностиОрганизаций.ФормаОбъекта", ПараметрыФормы,, УИДФормы);
	ИначеЕсли ТипЗнч(Результат.СсылкаНаДоверенность) = Тип(
		"СправочникСсылка.МашиночитаемыеДоверенностиКонтрагентов") Тогда
		ОткрытьФорму("Справочник.МашиночитаемыеДоверенностиКонтрагентов.ФормаОбъекта", ПараметрыФормы,, УИДФормы);
	Иначе
		ПоказатьЗначение(Новый ОписаниеОповещения, Результат.СсылкаНаДоверенность);
	КонецЕсли;

	Если Результат.ОткрытьФормуДляОбновления Тогда
		ТекстСообщения = НСтр("ru = 'Для обновления выполните: Еще - Обновить из реестра ФНС.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	Иначе
		ТекстСообщения = НСтр("ru = 'Доверенность успешно загружена.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьПерезаполнитьИзФайлаЗавершение(ПомещенныйФайл, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныйФайл = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	АдресВоВременномХранилище = ПомещенныйФайл.Хранение;
	МашиночитаемыеДоверенностиКлиент.ЗагрузитьМЧДИзФайла(АдресВоВременномХранилище);
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти
