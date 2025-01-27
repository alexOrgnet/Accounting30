﻿#Область СлужебныйПрограммныйИнтерфейс

// Запускает фоновое задание по обмену с сервисом АУСН
//
// Параметры:
// Идентификатор - УникальныйИдентификатор - ключ формы, которая инициировала выполнение фонового задания
//
Функция ВыполнитьОбменССервисомВФонеНаСервере(Идентификатор) Экспорт
	
	НастройкиЗапуска = ДлительныеОперации.ПараметрыВыполненияФункции(Идентификатор);
	НастройкиЗапуска.НаименованиеФоновогоЗадания = НСтр("ru = 'Обмен с сервисом АУСН'");
		
	НастройкиЗапуска.ОжидатьЗавершение = 0;
	НастройкиЗапуска.ЗапуститьВФоне = Истина;
	Адрес = ПоместитьВоВременноеХранилище(Неопределено, Идентификатор);
	
	Результат = ДлительныеОперации.ВыполнитьФункцию(
		НастройкиЗапуска,
		"ИнтеграцияАУСН.ВыполнитьОбменССервисом",
		Адрес);
	
	Возврат Результат;
	
КонецФункции

// Возвращает текст ошибки для документа с ошибкой заполнения
//
// Параметры:
//  ПараметрыДокумента - Структура -
//                       см. ЗагрузкаВыпискиПоБанковскомуСчету.НовыйПараметрыДокументаДляРаспознаванияОперации
//
// Возвращаемое значение:
//  Строка
//
Функция ТекстСообщенияОбОшибке(ПараметрыДокумента) Экспорт
	
	ЧастиСообщения = Новый Массив;
	Если РегистрыСведений.БанковскиеДокументыАУСН.ОперацияОтклоненаФНС(ПараметрыДокумента.Ссылка) Тогда
		ОтветФНС = РегистрыСведений.БанковскиеДокументыАУСН.ОтветФНС(ПараметрыДокумента.Ссылка);
	Иначе
		ОтветФНС = "";
		ЧастиСообщения.Добавить(НСтр(
			"ru = 'Ошибка заполнения документа, загруженного из сервиса АУСН'",
			ОбщегоНазначения.КодОсновногоЯзыка()));
	КонецЕсли;
	
	ТекстСообщения = РегистрыСведений.ПредупрежденияПриЗагрузкеВыписки.ПредупреждениеДляДокумента(
		ПараметрыДокумента);
	ЧастиСообщения.Добавить(ТекстСообщения);
	
	Если ЗначениеЗаполнено(ОтветФНС) Тогда
		ЧастиСообщения.Добавить(ОтветФНС);
		Попытка
			ОбъектОтветФНС = ИнтеграцияАУСН.РасшифроватьОтветФНС(ОтветФНС);
			ДокументыСОшибками = Новый Массив;
			Для Каждого СтатусОперации Из ОбъектОтветФНС.OperationStatuses Цикл
				Если ВРег(СтатусОперации.StatusCode) <> ИнтеграцияАУСНКлиентСервер.ИмяСтатусаПринятФНС() Тогда
					ДокументыСОшибками.Добавить(СтатусОперации.Id);
				КонецЕсли;
			КонецЦикла;
			ЧастиСообщения.Добавить(РегистрыСведений.БанковскиеДокументыАУСН.ДанныеВФорматеСервисаПоИдентификаторам(
				ДокументыСОшибками));
		Исключение
			Информация = ИнформацияОбОшибке();
			ИнтеграцияАУСН.ЗаписатьОшибкуВЖурналРегистрации(
				КраткоеПредставлениеОшибки(Информация), ПодробноеПредставлениеОшибки(Информация));
		КонецПопытки;
	Иначе
		ЧастиСообщения.Добавить(РегистрыСведений.БанковскиеДокументыАУСН.ДанныеВФорматеСервиса(ПараметрыДокумента.Ссылка));
	КонецЕсли;
	
	Возврат СтрСоединить(ЧастиСообщения, Символы.ПС);
	
КонецФункции

Функция СсылкаЛКБанкаИзСостоянияОбмена(АдресДанных) Экспорт
	
	ДанныеСостоянияОбмена = ПолучитьИзВременногоХранилища(АдресДанных);
	
	Если ЭтоАдресВременногоХранилища(ДанныеСостоянияОбмена.ОшибкиАУСН) Тогда
		ОшибкиОбмена = ПолучитьИзВременногоХранилища(ДанныеСостоянияОбмена.ОшибкиАУСН);
	Иначе
		ОшибкиОбмена = Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(ОшибкиОбмена) = Тип("ТаблицаЗначений") И ЗначениеЗаполнено(ОшибкиОбмена) Тогда
		СтрокаОшибка = ОшибкиОбмена[0];
		ПодключенныеБанки = РегистрыСведений.СостоянияИнтеграцииАУСН.Банки(
			СтрокаОшибка.Организация, СтрокаОшибка.ИдентификаторБанка);
		Если ПодключенныеБанки.Следующий() Тогда
			Возврат ИнтеграцияАУСНПовтИсп.СсылкаЛичныйКабинетБанка(ПодключенныеБанки.Банк);
		КонецЕсли;
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

Функция СсылкаЛКБанкаПоБанковскомуСчету(Счет) Экспорт
	
	БИК = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Счет, "Банк.Код");
	БанкПоКлассификатору = РаботаСБанкамиБП.СсылкаПоКлассификатору(БИК);
	Возврат ИнтеграцияАУСНПовтИсп.СсылкаЛичныйКабинетБанка(БанкПоКлассификатору);
	
КонецФункции

// Проверяет соответствие вида документа физического лица требованиям ФНС для обмена с сервисом АУСН
//
// Параметры:
//  ВидДокумента - СправочникСсылка.ВидыДокументовФизическихЛиц
//  ТекстОшибки - Строка - в этот параметр передается текст ошибки, если переданное значение не прошло проверку
//
// Возвращаемое значение:
//  Булево - признак того, что переданное значение соответствует требованиям, указанным в протоколе обмена
//
Функция ВидДокументаСоответствуетПротоколуОбмена(ВидДокумента, ТекстОшибки) Экспорт
	
	КодЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
	КодВидаДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидДокумента, "КодМВД");
	
	РезультатПроверки = Истина;
	
	Если ЗначениеЗаполнено(ВидДокумента) И Не ЗначениеЗаполнено(КодВидаДокумента) Тогда
		ТекстОшибки = НСтр("ru = 'Недопустимый вид документа'", КодЯзыка);
		РезультатПроверки = Ложь;
	ИначеЕсли Не ЗначениеЗаполнено(ВидДокумента) Тогда
		ТекстОшибки = НСтр("ru = 'Не заполнен вид документа'", КодЯзыка);
		РезультатПроверки = Ложь;
	Иначе
		ДопустимыеВидыДокументов = ИнтеграцияАУСНКлиентСервер.ДопустимыеВидыДокументовФизическихЛиц();
		Если ДопустимыеВидыДокументов.Найти(КодВидаДокумента) = Неопределено Тогда
			ТекстОшибки = НСтр("ru = 'Недопустимый вид документа'", КодЯзыка);
			РезультатПроверки = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Возврат РезультатПроверки;
	
КонецФункции

#КонецОбласти