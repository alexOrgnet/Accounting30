﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Проверяем данные последней версии
	
	РеквизитыВерсии = РеквизитыТекущейВерсии(ЭтотОбъект);
	Если РеквизитыВерсии = Неопределено Тогда
		РеквизитыВерсии = ЭтотОбъект;
	КонецЕсли;
	
	Отбор = Новый Структура;
	Отбор.Вставить("НомерВерсии", РеквизитыВерсии.НомерВерсии);
	
	ТоварыВерсии = Товары.Выгрузить(Отбор);
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	НепроверяемыеРеквизиты.Добавить("Товары.Номенклатура");
	НепроверяемыеРеквизиты.Добавить("Товары.Содержание");
	НепроверяемыеРеквизиты.Добавить("Товары.Количество");
	
	МассивНоменклатуры = ОбщегоНазначения.ВыгрузитьКолонку(ТоварыВерсии,"Номенклатура", Истина);
	
	ОбщегоНазначенияБПКлиентСервер.УдалитьНеЗаполненныеЭлементыМассива(МассивНоменклатуры);
	
	РеквизитыНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(МассивНоменклатуры, "Услуга");
	
	Если УчетНДСПереопределяемый.ПолучитьСуммуДокументаСНДС(ЭтотОбъект, , , Отбор) < 0 И РеквизитыВерсии.СуммаСкидки > 0 Тогда
		
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,"КОРРЕКТНОСТЬ", НСтр("ru = 'Скидка'"), , ,
			НСтр("ru = 'Сумма скидки превышает сумму по документу'"));
		Поле = "СуммаСкидки";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		
	КонецЕсли;
	
	Для Каждого СтрокаТаблицы Из ТоварыВерсии Цикл
		
		Префикс = "Товары[%1].";
		Префикс = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Префикс, Формат(СтрокаТаблицы.НомерСтроки - 1, "ЧН=0; ЧГ="));
		
		ИмяСписка = НСтр("ru = 'Товары'");
		
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.Номенклатура)
			И ПустаяСтрока(СтрокаТаблицы.Содержание) Тогда
		
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка", "Заполнение",
				НСтр("ru = 'Номенклатура'") , СтрокаТаблицы.НомерСтроки, ИмяСписка, ТекстСообщения);
			Поле = Префикс + "Номенклатура";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		
		КонецЕсли;
		
		Всего = СтрокаТаблицы.Сумма + ?(СуммаВключаетНДС, 0, СтрокаТаблицы.СуммаНДС);
		Если Всего > 0 И СтрокаТаблицы.СуммаСкидки > Всего Тогда
		
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка","КОРРЕКТНОСТЬ", НСтр("ru = 'Скидка'"),
				СтрокаТаблицы.НомерСтроки, ИмяСписка, НСтр("ru = 'Сумма скидки превышает сумму по строке'"));
			Поле = Префикс + "СуммаСкидки";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		
		КонецЕсли;
		
		СвойстваНоменклатуры = РеквизитыНоменклатуры[СтрокаТаблицы.Номенклатура];
		ЭтоУслуга = ?(СвойстваНоменклатуры <> Неопределено, СвойстваНоменклатуры.Услуга, Истина);
		
		Если Не ЭтоУслуга И Не ЗначениеЗаполнено(СтрокаТаблицы.Количество) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка", , НСтр("ru = 'Количество'"),
				СтрокаТаблицы.НомерСтроки, ИмяСписка);
			Поле = Префикс + "Количество";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	НомерВерсии = 1;
	ДатаВерсии = Дата;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И ДанныеЗаполнения.Свойство("АдресТаблицыНоменклатуры") Тогда
		ПараметрыОбъекта = РаботаСНоменклатуройБП.НовыеПараметрыОбъекта();
		ЗаполнитьЗначенияСвойств(ПараметрыОбъекта, ЭтотОбъект);
		Если Не ЗначениеЗаполнено(ПараметрыОбъекта.ТипЦен) Тогда
			ПараметрыОбъекта.Вставить("СпособЗаполненияЦены", Перечисления.СпособыЗаполненияЦен.ПоПродажнымЦенам);
		КонецЕсли;
		ПараметрыОбъекта.Реализация = Истина;
		ОбработкаТабличныхЧастей.ЗаполнитьИзТаблицыНоменклатуры(
			Товары, ДанныеЗаполнения.АдресТаблицыНоменклатуры, ПараметрыОбъекта);
		Для Каждого СтрокаТовары Из Товары Цикл
			СтрокаТовары.НомерВерсии = НомерВерсии;
		КонецЦикла;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И ДанныеЗаполнения.Свойство("СуммаВключаетНДС") Тогда
		СуммаВключаетНДС = ДанныеЗаполнения.СуммаВключаетНДС;
	Иначе
		СуммаВключаетНДС = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию(
			"ОсновнойВариантРасчетаИсходящегоНДС") = Перечисления.ВариантыРасчетаНДС.НДСВСумме;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Дата) Тогда
		СрокДействия = Документы.КоммерческоеПредложение.СрокДействияПоУмолчанию(Дата);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(КонтактноеЛицо) И ЗначениеЗаполнено(Контрагент) Тогда
		КонтактноеЛицо = Контрагент.ОсновноеКонтактноеЛицо;
	КонецЕсли;
	
	НовыеРеквизиты = РеквизитыВерсий.Добавить();
	ЗаполнитьЗначенияСвойств(НовыеРеквизиты, ЭтотОбъект);
	НовыеРеквизиты.ТекущаяВерсия = Истина;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыВерсии = РеквизитыТекущейВерсии(ЭтотОбъект);
	Если РеквизитыВерсии <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыВерсии);
		
		Отбор = Новый Структура;
		Отбор.Вставить("НомерВерсии", РеквизитыВерсии.НомерВерсии);
	Иначе
		Отбор = Неопределено;
	КонецЕсли;
	
	// Посчитать суммы документа и записать ее в соответствующий реквизит шапки для показа в журналах
	СуммаДокумента = УчетНДСПереопределяемый.ПолучитьСуммуДокументаСНДС(ЭтотОбъект, , , Отбор);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПометкаУдаления Тогда
		Справочники.КонтактныеЛица.УстановитьВладельцаКонтактногоЛица(КонтактноеЛицо, Контрагент);
	КонецЕсли;
	
	КалькуляцииРасходов.ПриЗаписиДокумента(ЭтотОбъект, "Товары");
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	
	НомерВерсии = 1;
	ДатаВерсии = Дата;
	Комментарий = "";
	
	СрокДействия = Документы.КоммерческоеПредложение.СрокДействияПоУмолчанию(Дата);
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	ОтветственныеЛицаБП.УстановитьОтветственныхЛиц(ЭтотОбъект);
	
	СтруктураКурсаВзаиморасчетов = РаботаСКурсамиВалют.ПолучитьКурсВалюты(
		ВалютаДокумента, Дата);
	
	КурсВзаиморасчетов = СтруктураКурсаВзаиморасчетов.Курс;
	КратностьВзаиморасчетов = СтруктураКурсаВзаиморасчетов.Кратность;
	
	РаботаСНоменклатуройБП.ОбновитьСодержаниеУслуг(Товары, Дата);
	
	ЗаполнениеДокументов.ПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
	РеквизитыВерсий.Очистить();
	
	НовыеРеквизиты = РеквизитыВерсий.Добавить();
	ЗаполнитьЗначенияСвойств(НовыеРеквизиты, ЭтотОбъект);
	НовыеРеквизиты.ТекущаяВерсия = Истина;
	
	Отбор = Новый Структура;
	Отбор.Вставить("НомерВерсии", ОбъектКопирования.НомерВерсии);
	
	ТоварыВерсии = ОбъектКопирования.Товары.Выгрузить(Отбор);
	
	Товары.Очистить();
	
	Для Каждого СтрокаТовары Из ТоварыВерсии Цикл
		НоваяСтрока = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТовары);
		НоваяСтрока.НомерВерсии = НомерВерсии;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция РеквизитыТекущейВерсии(ДокументОбъект)
	
	Отбор = Новый Структура("ТекущаяВерсия", Истина);
	
	ВсеВерсии = ДокументОбъект.РеквизитыВерсий.НайтиСтроки(Отбор);
	Если ВсеВерсии.Количество() > 0 Тогда
		Возврат ВсеВерсии[0];
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли
