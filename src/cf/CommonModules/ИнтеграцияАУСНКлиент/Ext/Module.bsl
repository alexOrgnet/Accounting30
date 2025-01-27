﻿#Область ПрограммныйИнтерфейс

// Открывает помощник подключения сервиса.
// 
// Параметры:
//   Организация -ОпределяемыйТип.Организация, Неопределено - организация
//   Банк - СправочникСсылка.КлассификаторБанков, Неопределено - банк
//
Процедура ОткрытьПомощникПодключенияСервиса(Организация = Неопределено, Банк = Неопределено) Экспорт
	
	ПараметрыФормы = Новый Структура;
	Если Организация <> Неопределено Тогда
		ПараметрыФормы.Вставить("Организация", Организация);
	КонецЕсли;
	Если Банк <> Неопределено Тогда
		ПараметрыФормы.Вставить("Банк", Банк);
	КонецЕсли;
	
	ОткрытьФорму("Обработка.ПодключениеАУСН.Форма.Форма", ПараметрыФормы, , Неопределено);
	
КонецПроцедуры

// Открывает веб-страницу личного кабинета банка, подключенного к сервису АУСН,
// если ссылка на личный кабинет есть в регистре сведений БанкиАУСН
//
// Параметры:
//  АдресДанных - Строка - ссылка на временное хранилище, в котором хранятся данные
//                о состоянии обмена АУСН. см регистр сведений СостоянияИнтеграцииАУСН.НовыйСведенияОбОбмене
//
Процедура ОткрытьЛКБанка(АдресДанных) Экспорт
	
	СсылкаЛК = ИнтеграцияАУСНВызовСервера.СсылкаЛКБанкаИзСостоянияОбмена(АдресДанных);
	
	Если ЗначениеЗаполнено(СсылкаЛК) Тогда
		ПерейтиПоНавигационнойСсылке(СсылкаЛК);
	КонецЕсли;
	
КонецПроцедуры

// Открывает веб-страницу личного кабинета банка, подключенного к сервису АУСН,
// если ссылка на личный кабинет есть в регистре сведений БанкиАУСН
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма документа ПоступлениенаРасчетныйСчет или СписаниеСРасчетногоСчета
//
Процедура ОткрытьЛКБанкаИзФормыДокумента(Форма) Экспорт
	
	СсылкаЛК = ИнтеграцияАУСНВызовСервера.СсылкаЛКБанкаПоБанковскомуСчету(Форма.Объект.СчетОрганизации);
	Если ЗначениеЗаполнено(СсылкаЛК) Тогда
		ПерейтиПоНавигационнойСсылке(СсылкаЛК);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Вызывается при начале обработки ошибки сервиса АУСН или портала ИТС.
// Если нужно, показывает форму подключения интернет-поддержки
// или форму ввода одноразового пароля из SMS-сообщения.
// Затем возвращает управление в вызываюшую форму для дальнейшей обработки ошибки.
//
// Параметры:
//	ОповещениеФормыВладельца - ОписаниеОповещения - обработчик оповещения о завершении.
//          Структура ДополнительныеПараметры оповещения должны содержать свойства:
//          * ФормаВладелец - Форма - форма, из которой вызывается процедура.
//          В обработчик оповещения возвращается структура с ключом "Действие". Возможные действия:
//          "Повторить" - нужно повторить запрос к сервису после успешного подключения интернет-поддержки 
//                          или успешного ввода одноразового пароля.
//          "Продолжить" - можно продолжить обработку ошибки в вызывающей форме.
//                          Подключать интернет-поддержку или вводить пароль было не нужно.
//          "Ошибка" - Интернет-поддержка не была подключена или пароль не был введен.
//                       Дальнейшая обработка такой ситуации производится в вызывающей форме. 
//
Процедура ОтобразитьПодключениеКПорталу(ОповещениеФормыВладельца) Экспорт
	
	ФормаВладелец = ОповещениеФормыВладельца.ДополнительныеПараметры.ФормаВладелец;
	
	ПараметрыПродолжения = Новый Структура;
	ПараметрыПродолжения.Вставить("Действие", Неопределено);
	ПараметрыПродолжения.Вставить("ОповещениеФормыВладельца", ОповещениеФормыВладельца);
	
	Если ИнтернетПоддержкаПользователейКлиент.ДоступноПодключениеИнтернетПоддержки() Тогда
		ПараметрыПродолжения.Действие = "ИнтернетПоддержка";
		ПараметрыПродолжения.Вставить("ФормаВладелец", ФормаВладелец);
		ОбработчикПродолжения = Новый ОписаниеОповещения("ПодключитьИнтернетПоддержку", 
			ЭтотОбъект, ПараметрыПродолжения);
		ТекстВопроса = НСтр("ru='Для подключения к сервису АУСН
			|нужно подключить Интернет-поддержку пользователей.
			|Продолжить?'");
		ПоказатьВопрос(ОбработчикПродолжения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ПараметрыПродолжения.Действие = "ИнтернетПоддержкаНедоступна";
		ОбработчикПродолжения = Новый ОписаниеОповещения("ПродолжитьБезИнтернетПоддержки", 
			ЭтотОбъект, ПараметрыПродолжения);
		ТекстПредупреждения = НСтр("ru='Для подключения к сервису АУСН
			|нужно подключить Интернет-поддержку пользователей.
			|Обратитесь к администратору.'");
		ПоказатьПредупреждение(ОбработчикПродолжения, ТекстПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

// Обработка оповещения на утвердительный ответ вопроса с предложением подключить интенет-поддержку
// 
// Параметры:
//   Ответ - КодВозвратаДиалога
//   ПараметрыПродолжения - Структура
//
Процедура ПодключитьИнтернетПоддержку(Ответ, ПараметрыПродолжения) Экспорт

	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОбработчикПродолжения = Новый ОписаниеОповещения("ПродолжитьОбработкуОшибки", ЭтотОбъект, ПараметрыПродолжения);
		ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(
			ОбработчикПродолжения, ПараметрыПродолжения.ФормаВладелец);
	Иначе
		ПродолжитьБезИнтернетПоддержки(ПараметрыПродолжения);
	КонецЕсли;
	
КонецПроцедуры

// Обработка оповещения на отрицательный ответ вопроса с предложением подключить интенет-поддержку
// 
// Параметры:
//   ПараметрыПродолжения - Структура
//
Процедура ПродолжитьБезИнтернетПоддержки(ПараметрыПродолжения) Экспорт
	
	ПродолжитьОбработкуОшибки(Неопределено, ПараметрыПродолжения);
	
КонецПроцедуры

// Обработка оповещения, вызываемая после завершения подключения интернет-поддержки
// 
// Параметры:
//   РезультатДействия - Структура, Неопределено - результат подключения
//   ПараметрыПродолжения - Структура
//
Процедура ПродолжитьОбработкуОшибки(РезультатДействия, ПараметрыПродолжения) Экспорт
	
	Действие = ПараметрыПродолжения.Действие;
	ОбработчикПродолжения = ПараметрыПродолжения.ОповещениеФормыВладельца;
	
	Результат = Новый Структура("Действие");
	
	Если Действие = Неопределено Тогда
		
		Результат.Действие = "Продолжить";
		
	ИначеЕсли РезультатДействия = Неопределено Тогда
	
		Результат.Действие = "Ошибка";
		
	Иначе
		
		Результат.Действие = "Повторить";
		
	КонецЕсли;

	ВыполнитьОбработкуОповещения(ОбработчикПродолжения, Результат);
	
КонецПроцедуры

// Открывает журнал регистрации с отбором по имени события
//
// Параметры:
//    Уровни - Массив из Строка, Неопределено - отбор по уровням
//
Процедура ОткрытьЖурналРегистрации(Уровни = Неопределено) Экспорт
	
	ОтборЖурнала = Новый Структура;
	ОтборЖурнала.Вставить("СобытиеЖурналаРегистрации", ИнтеграцияАУСНКлиентСервер.ИмяСобытияЖурналаРегистрации());
	
	Если Уровни <> Неопределено Тогда
		ОтборЖурнала.Вставить("Уровень", Уровни);
	КонецЕсли;
	
	ЖурналРегистрацииКлиент.ОткрытьЖурналРегистрации(ОтборЖурнала);
	
КонецПроцедуры

Процедура ОбработкаНавигационнойСсылки(Форма, НавигационнаяСсылка, СтандартнаяОбработка) Экспорт
	
	Если НавигационнаяСсылка =
		РаботаСОповещениямиОСостоянииОбменаССервисамиКлиентСервер.ИмяДействияОбращениеВТехподдержку1С() Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьОбращениеВТехподдержку1С(Форма);
	ИначеЕсли НавигационнаяСсылка =
		РаботаСОповещениямиОСостоянииОбменаССервисамиКлиентСервер.ИмяДействияИнформацияОбОтклоненнойОперацииАУСН() Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьИнформациюОбОтклоненнойОперацииАУСН(Форма);
	ИначеЕсли НавигационнаяСсылка =
		РаботаСОповещениямиОСостоянииОбменаССервисамиКлиентСервер.ИмяДействияЛичныйКабинетБанка() Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьЛКБанкаИзФормыДокумента(Форма);
	КонецЕсли;
	
КонецПроцедуры

#Область ОбменССервисом

Процедура ВыполнитьОбменССервисом(Форма, ВыводитьОкноОжидания = Ложь) Экспорт
	
	Если Не ИнтеграцияАУСНВызовСервераПовтИсп.СервисПодключен() Тогда
		Возврат;
	КонецЕсли;
	
	ДлительнаяОперация = ИнтеграцияАУСНВызовСервера.ВыполнитьОбменССервисомВФонеНаСервере(Форма.УникальныйИдентификатор);
	
	Если ДлительнаяОперация = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДлительнаяОперация.Статус <> "Ошибка" Тогда
		НастройкиОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Форма);
		НастройкиОжидания.ВыводитьОкноОжидания = ВыводитьОкноОжидания;
		ПараметрыОбработчика = Новый Структура("ФормаВладелец", Форма);
		Обработчик = Новый ОписаниеОповещения("ОбработкаВыполненияОбменаЗавершение", ЭтотОбъект, ПараметрыОбработчика);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Обработчик, НастройкиОжидания);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаВыполненияОбменаЗавершение(ДлительнаяОперация, ДополнительныеПараметры) Экспорт
	
	Если ДлительнаяОперация = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ФормаВладелец = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
		ДополнительныеПараметры, "ФормаВладелец", Неопределено);
	
	Если ДлительнаяОперация.Статус <> "Ошибка" Тогда
		РезультатОбмена = ПолучитьИзВременногоХранилища(ДлительнаяОперация.АдресРезультата);
		Если РезультатОбмена.ЗагруженыНовыеВыписки Тогда
			ОповеститьОбИзменении(Тип("ДокументСсылка.ПоступлениеНаРасчетныйСчет"));
			ОповеститьОбИзменении(Тип("ДокументСсылка.СписаниеСРасчетногоСчета"));
		КонецЕсли;
		ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.ЗадачиБухгалтера"));
		ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.ДокументыАУСН"));
		Оповестить(ИмяСобытияОбменССервисом(), РезультатОбмена.ОшибкиОтправки, ФормаВладелец);
	КонецЕсли;
	
КонецПроцедуры

Функция ИмяСобытияОбменССервисом() Экспорт
	
	Возврат "ВыполненОбменССервисомАУСН";
	
КонецФункции

Функция ИмяСобытияИсправленыОшибкиОбмена() Экспорт
	
	Возврат "ИсправленыОшибкиОбменаАУСН";
	
КонецФункции

Функция ИмяСобытияИзмененияВОшибкахОтправки() Экспорт
	
	Возврат "ИзмененыОшибкиОтправкиАУСН";
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОткрытьОбращениеВТехподдержку1С(Форма)
	
	Объект = Форма.Объект;
	
	ПараметрыДокумента = ЗагрузкаВыпискиПоБанковскомуСчетуВызовСервера.НовыйПараметрыДокументаДляРаспознаванияОперации();
	ЗаполнитьЗначенияСвойств(ПараметрыДокумента, Объект);
	
	ПараметрыОбращения =
		РаботаСОповещениямиОСостоянииОбменаССервисамиВызовСервера.ПараметрыОбращенияВТехподдержкуОшибкаАУСН(
			ПараметрыДокумента);
		
	Если ПараметрыОбращения.ЭтоРежимСервиса Тогда
		ПараметрыФормы = Новый Структура("СоздаватьСообщение", Истина);
		ФормаОбращения = ПолучитьФорму(
			"Обработка.ИнформационныйЦентр.Форма.ОтправкаСообщенияВСлужбуПоддержки",
			ПараметрыФормы,
			Форма,
			Форма.УникальныйИдентификатор);
		ФормаОбращения.Тема = ПараметрыОбращения.Тема;
		ФормаОбращения.Содержание.Удалить();
		ФормаОбращения.Содержание.Добавить(
			ПараметрыОбращения.ПорядокВоспроизведения, Тип("ТекстФорматированногоДокумента"));
	Иначе
		ПараметрыФормы = Новый Структура("ТипСообщения", "Ошибка");
		
		ФормаОбращения = ПолучитьФорму(
			"Обработка.ОбращениеВТехническуюПоддержку.Форма.ОбращениеВПоддержку",
			ПараметрыФормы,
			Форма,
			Форма.УникальныйИдентификатор);
		
		ЗаполнитьЗначенияСвойств(ФормаОбращения, ПараметрыОбращения);
	КонецЕсли;
	
	ФормаОбращения.Открыть();
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
		РаботаСОповещениямиОСостоянииОбменаССервисамиКлиентСервер.ИмяДействияОбращениеВТехподдержку1С(),
		РаботаСОповещениямиОСостоянииОбменаССервисамиКлиентСервер.ИмяКлючаНастроекДатаОбращенияВТехподдержку1С(),
		ОбщегоНазначенияКлиент.ДатаСеанса());
	
КонецПроцедуры

Процедура ОткрытьИнформациюОбОтклоненнойОперацииАУСН(Форма)
	
	Объект = Форма.Объект;
	ПараметрыФормы =
		РаботаСОповещениямиОСостоянииОбменаССервисамиВызовСервера.ПараметрыФормыИнформацииОбОшибкеАУСН_ОтклоненФНС(
			Объект.Ссылка);
	ОткрытьФорму("ОбщаяФорма.ИнформацияОбОшибкеОбменаАУСН", ПараметрыФормы, , Форма.УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти