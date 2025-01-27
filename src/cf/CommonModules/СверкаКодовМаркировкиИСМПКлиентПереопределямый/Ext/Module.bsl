﻿
#Область СобытияФорм

// Заполняет специфичные параметры открытия формы результатов сверки кодов маркировки в зависимости от точки вызова.
// Например, определяет доступность функционала по согласованию расхождений и заполняет признак режима проверки входящего электронного документа.
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма из которой происходит открытие формы результатов сверки кодов маркировки.
//  Параметры - Структура - (См. СверкаКодовМаркировкиИСМПКлиент.ПараметрыОткрытияФормыСверки).
//
Процедура ПриУстановкеПараметровОткрытияФормыСверкиКодовМаркировки(Форма, Параметры) Экспорт

	//++ НЕ ГОСИС
	Если ИнтеграцияИСБПКлиентСервер.ЭтоДокументПоНаименованию(Форма, "АктОРасхожденияхПолученный") Тогда
		Параметры.ИмяРеквизитаДокументОснования  = "ДокументРеализации";
		Параметры.ЗаголовокФормы = "Результаты сверки по кодам маркировки отгруженной продукции";
		Параметры.ДоступноСогласованиеРасхождений = Истина;
		Параметры.ИмяТабличнойЧастиШтрихкодыУпаковокФакт = "ШтрихкодыУпаковок";
		Параметры.ИмяТабличнойЧастиШтрихкодыУпаковокРасхождения = "ШтрихкодыУпаковокРасхождения";
	ИначеЕсли ИнтеграцияИСБПКлиентСервер.ЭтоДокументПоНаименованию(Форма, "АктОРасхождениях") Тогда
		Параметры.ЗаголовокФормы = "Результаты сверки по кодам маркировки поступившей продукции";
		Параметры.ДоступноСогласованиеРасхождений = Ложь;
		Параметры.РедактированиеФормыНедоступно = Истина;
		Параметры.ИмяТабличнойЧастиШтрихкодыУпаковокФакт = "ШтрихкодыУпаковок";
		Параметры.ИмяТабличнойЧастиШтрихкодыУпаковокРасхождения = "ШтрихкодыУпаковокРасхождения";
		Параметры.ВосстановитьПоДаннымПроверкиПодбора = Истина;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма,"ПараметрыИнтеграцииГосИС") Тогда
		
		НастройкиИнтеграции = Форма.ПараметрыИнтеграцииГосИС.Получить("ФормаСверкиИСМП");
		Если Не(НастройкиИнтеграции = Неопределено) Тогда
			Параметры.ПроверкаЭлектронногоДокумента = НастройкиИнтеграции.ЕстьЭлектронныйДокумент;
			//Параметры.РедактированиеФормыНедоступно = Параметры.РедактированиеФормыНедоступно Или НастройкиИнтеграции.ЗавершенОбменПоЭДО;
		КонецЕсли;
		
	КонецЕсли;
	//-- НЕ ГОСИС

КонецПроцедуры

// Выполняет специфичные действия перед открытием формы результатов сверки кодов маркировки в зависимости от точки вызова.
// Для открытия результатов сверки из документа, полученного по ЭДО (например, акт о расхождениях, корректировка приобретения) необходимо 
// проверить заполненность реквизита документ-основание. (см. ПараметрыОткрытия.ИмяКоллекцииДокументыОснование, ПараметрыОткрытия.ИмяРеквизитаДокументОснования).
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма из которой происходит открытие формы сверки кодов маркировки.
//  ПараметрыОткрытия - Структура - (См. СверкаКодовМаркировкиИСМПКлиент.ПараметрыОткрытияФормыСверки()).
//  ПараметрыФормыПроверки - Структура - подготовленные параметры открытия формы сверки кодов маркировки.
//  Отказ - Булево - отказ от открытия формы.
//
Процедура ПередОткрытиемФормыРезультатыСверкиКодовМаркировки(Форма, ПараметрыОткрытия, ПараметрыФормыПроверки, Отказ) Экспорт
	
	
	//++ НЕ ГОСИС
	Если ИнтеграцияИСБПКлиентСервер.ЭтоДокументПоНаименованию(Форма, "АктОРасхожденияхПолученный") Тогда
		ДокументОснованиеНайден = Истина;
		Если ЗначениеЗаполнено(ПараметрыОткрытия.ИмяКоллекцииДокументыОснование) Тогда
			ДанныеФормыДокументыОснования = Форма[ПараметрыОткрытия.ИмяКоллекцииДокументыОснование];
			Если ДанныеФормыДокументыОснования.Количество() = 0 Тогда
				ДокументОснованиеНайден = Ложь;
			КонецЕсли;
		КонецЕсли;
		
		Если Не ДокументОснованиеНайден Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Не найдены документы-основания'"),,
				ПараметрыОткрытия.ИмяКоллекцииДокументыОснование,
				ПараметрыОткрытия.ИмяРеквизитаФормыОбъект,
				Отказ);
		КонецЕсли;
	КонецЕсли;
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Выполняет специфичные действия после закрытия форм сверки кодов маркировки в зависимости от точки вызова
//
// Параметры:
//  РезультатЗакрытия - Произвольный - результат закрытия формы проверки и подбора
//  ДополнительныеПараметры - Структура - структура с реквизитом Форма (управляемая форма из которой происходил вызов)
//
Процедура ПриЗакрытииФормыСверкиКодовМаркировки(РезультатЗакрытия, ДополнительныеПараметры) Экспорт

	ДополнительныеПараметры.Форма.Прочитать();
	Возврат;
	
КонецПроцедуры

#КонецОбласти
