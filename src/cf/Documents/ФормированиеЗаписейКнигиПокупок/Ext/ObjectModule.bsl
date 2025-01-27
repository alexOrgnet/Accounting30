﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

/////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.ФормированиеЗаписейКнигиПокупок.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	
	УчетНДС.СформироватьДвиженияВычетНДСПоПриобретеннымЦенностям(
		ПараметрыПроведения.Реквизиты, ПараметрыПроведения.ТаблицаВычетПоПриобретеннымЦенностям, Движения, Отказ);
	
	Документы.ФормированиеЗаписейКнигиПокупок.СформироватьДвиженияВычетНДССВыданногоАванса(
		ПараметрыПроведения.Реквизиты, ПараметрыПроведения.ТаблицаПоАвансамВыданным, Движения, Отказ);
			
	Документы.ФормированиеЗаписейКнигиПокупок.СформироватьДвиженияВычетНДСПриЗачетеПолученногоАванса(
		ПараметрыПроведения.Реквизиты, ПараметрыПроведения.ТаблицаПоАвансамПолученным, Движения, Отказ);
		
	УчетНДС.СформироватьДвиженияВычетНДСПоПриобретеннымЦенностям(
		ПараметрыПроведения.Реквизиты, ПараметрыПроведения.ТаблицаВычетНДСПоНалоговомуАгенту, Движения, Отказ);
		
	УчетНДС.СформироватьДвиженияВычетНДСПоПриобретеннымЦенностям(
		ПараметрыПроведения.Реквизиты, ПараметрыПроведения.ТаблицаВычетПриИзмененииСтоимостиВСторонуУменьшения, Движения, Отказ);
		
	РегистрыСведений.ВыполнениеРегламентныхОперацийНДС.СформироватьДвиженияФактВыполненияРегламентнойОперации(
		ПараметрыПроведения.ДанныеРегламентнойОперации, Отказ);
		
	ПроведениеСервер.УстановитьЗаписьОчищаемыхНаборовЗаписей(ЭтотОбъект);
		
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	РегистрыСведений.ВыполнениеРегламентныхОперацийНДС.СброситьФактВыполненияОперации(Ссылка);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();
	
	ПредъявленНДСКВычету0 = Ложь;
	ДокументСозданВПомощнике = Ложь;
	
	ВычетПоПриобретеннымЦенностям.Очистить();
	НДСсАвансов.Очистить();
	НДСсАвансовВыданных.Очистить();
	ВычетНДСПоНалоговомуАгенту.Очистить();
	ВычетПриИзмененииСтоимостиВСторонуУменьшения.Очистить();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	МассивНепроверяемыхРеквизитов = Новый Массив();
	МассивНепроверяемыхРеквизитов.Добавить("ВычетПоПриобретеннымЦенностям.Поставщик");
	МассивНепроверяемыхРеквизитов.Добавить("ВычетПоПриобретеннымЦенностям.КорректируемыйПериод");
	МассивНепроверяемыхРеквизитов.Добавить("ВычетПоПриобретеннымЦенностям.НомерДокументаОплаты");
	МассивНепроверяемыхРеквизитов.Добавить("ВычетПоПриобретеннымЦенностям.ДатаДокументаОплаты");
	МассивНепроверяемыхРеквизитов.Добавить("ВычетПоПриобретеннымЦенностям.ДокументОплаты");
	МассивНепроверяемыхРеквизитов.Добавить("НДСсАвансов.КорректируемыйПериод");
	МассивНепроверяемыхРеквизитов.Добавить("НДСсАвансовВыданных.КорректируемыйПериод");
	МассивНепроверяемыхРеквизитов.Добавить("ВычетНДСПоНалоговомуАгенту.КорректируемыйПериод");
	МассивНепроверяемыхРеквизитов.Добавить("ВычетНДСПоНалоговомуАгенту.ДокументОплаты");
	МассивНепроверяемыхРеквизитов.Добавить("ВычетНДСПоНалоговомуАгенту.СчетФактура");
	МассивНепроверяемыхРеквизитов.Добавить("ВычетПриИзмененииСтоимостиВСторонуУменьшения.Поставщик");
	
	Если НЕ ПредъявленНДСКВычету0 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВычетПоПриобретеннымЦенностям.ДокументОтгрузки");
		МассивНепроверяемыхРеквизитов.Добавить("ВычетПоПриобретеннымЦенностям.Состояние");
		МассивНепроверяемыхРеквизитов.Добавить("ВычетНДСПоНалоговомуАгенту.ДокументОтгрузки");
		МассивНепроверяемыхРеквизитов.Добавить("ВычетНДСПоНалоговомуАгенту.Состояние");
	КонецЕсли;
	
	КлассифицироватьНоменклатуруПоОперациям0 = УчетНДСВызовСервера.КлассифицироватьНоменклатуруПоОперациям0(Дата, Организация);
	
	Для каждого СтрокаТаблицы Из ВычетПоПриобретеннымЦенностям Цикл
		
		Префикс = "ВычетПоПриобретеннымЦенностям[" + Формат(СтрокаТаблицы.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";
		ИмяСписка = НСтр("ru = 'Приобретенные ценности'");
	
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.Поставщик)
			И НЕ СтрокаТаблицы.ВидЦенности = Перечисления.ВидыЦенностей.СМРСобственнымиСилами Тогда
			
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, 
							НСтр("ru = 'Поставщик'"), 
							СтрокаТаблицы.НомерСтроки, ИмяСписка);
			Поле = Префикс + "Поставщик"; 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаТаблицы.КодВидаОперации) 
			И Не УчетНДСКлиентСервер.ФорматныйКонтрольКодаВидаОперацииПройден(СтрокаТаблицы.КодВидаОперации) Тогда
			
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка", "Корректность",
				НСтр("ru = 'Код операции'"), СтрокаТаблицы.НомерСтроки, ИмяСписка,
				НСтр("ru='Код вида операции может содержать только цифры и символ "";""'"));
			Поле = Префикс + "КодВидаОперации";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			
		КонецЕсли;
		
		Если ПредъявленНДСКВычету0
			И КлассифицироватьНоменклатуруПоОперациям0
			И НЕ ЗначениеЗаполнено(СтрокаТаблицы.КодОперации0) Тогда
			
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",,
				НСтр("ru = 'Код операции НДС 0%'"), СтрокаТаблицы.НомерСтроки, ИмяСписка);
			Поле = Префикс + "КодОперации0";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			
		КонецЕсли;
		
		Если СтрокаТаблицы.ЗаписьДополнительногоЛиста И НЕ ЗначениеЗаполнено(СтрокаТаблицы.КорректируемыйПериод) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, 
							НСтр("ru = 'Корректируемый период'"), 
							СтрокаТаблицы.НомерСтроки, ИмяСписка);
			Поле = Префикс + "КорректируемыйПериод"; 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
		Если СтрокаТаблицы.ВидЦенности = Перечисления.ВидыЦенностей.ЭлектронныеУслуги Тогда
			
			Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.ДатаДокументаОплаты) Тогда
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, 
								НСтр("ru = 'Дата док. оплаты'"), 
								СтрокаТаблицы.НомерСтроки, ИмяСписка);
				Поле = Префикс + "ДатаДокументаОплаты"; 
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.НомерДокументаОплаты) Тогда
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, 
								НСтр("ru = 'Номер док. оплаты'"), 
								СтрокаТаблицы.НомерСтроки, ИмяСписка);
				Поле = Префикс + "НомерДокументаОплаты"; 
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.ДокументОплаты) Тогда
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, 
								НСтр("ru = 'Документ оплаты'"), 
								СтрокаТаблицы.НомерСтроки, ИмяСписка);
				Поле = Префикс + "ДокументОплаты"; 
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			КонецЕсли;
			
		Иначе
			
			Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.ДатаДокументаОплаты)
				И ЗначениеЗаполнено(СтрокаТаблицы.НомерДокументаОплаты) Тогда
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, 
								НСтр("ru = 'Дата док. оплаты'"), 
								СтрокаТаблицы.НомерСтроки, ИмяСписка);
				Поле = Префикс + "ДатаДокументаОплаты"; 
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.НомерДокументаОплаты)
				И ЗначениеЗаполнено(СтрокаТаблицы.ДатаДокументаОплаты) Тогда
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, 
								НСтр("ru = 'Номер док. оплаты'"), 
								СтрокаТаблицы.НомерСтроки, ИмяСписка);
				Поле = Префикс + "НомерДокументаОплаты"; 
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для каждого СтрокаТаблицы Из НДСсАвансов Цикл
	
		Префикс = "НДСсАвансов[" + Формат(СтрокаТаблицы.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";
		ИмяСписка = НСтр("ru = 'Полученные авансы'");
	
		Если СтрокаТаблицы.ЗаписьДополнительногоЛиста И НЕ ЗначениеЗаполнено(СтрокаТаблицы.КорректируемыйПериод) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, 
							НСтр("ru = 'Корректируемый период'"), 
							СтрокаТаблицы.НомерСтроки, ИмяСписка);
			Поле = Префикс + "КорректируемыйПериод"; 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.ДатаДокументаОплаты)
			И ЗначениеЗаполнено(СтрокаТаблицы.НомерДокументаОплаты) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, 
							НСтр("ru = 'Дата документа оплаты'"), 
							СтрокаТаблицы.НомерСтроки, ИмяСписка);
			Поле = Префикс + "ДатаДокументаОплаты"; 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.НомерДокументаОплаты)
			И ЗначениеЗаполнено(СтрокаТаблицы.ДатаДокументаОплаты) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, 
							НСтр("ru = 'Номер документа оплаты'"), 
							СтрокаТаблицы.НомерСтроки, ИмяСписка);
			Поле = Префикс + "НомерДокументаОплаты"; 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
	
	КонецЦикла;
	
	Для каждого СтрокаТаблицы Из НДСсАвансовВыданных Цикл
		
		Префикс = "НДСсАвансовВыданных[" + Формат(СтрокаТаблицы.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";
		ИмяСписка = НСтр("ru = 'Выданные авансы'");
		
		Если СтрокаТаблицы.ЗаписьДополнительногоЛиста И НЕ ЗначениеЗаполнено(СтрокаТаблицы.КорректируемыйПериод) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, 
							НСтр("ru = 'Корректируемый период'"), 
							СтрокаТаблицы.НомерСтроки, ИмяСписка);
			Поле = Префикс + "КорректируемыйПериод"; 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
	Для каждого СтрокаТаблицы Из ВычетНДСПоНалоговомуАгенту Цикл
		
		Префикс = "ВычетНДСПоНалоговомуАгенту[" + Формат(СтрокаТаблицы.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";
		ИмяСписка = НСтр("ru = 'Налоговый агент'");
		
		Если СтрокаТаблицы.ЗаписьДополнительногоЛиста И НЕ ЗначениеЗаполнено(СтрокаТаблицы.КорректируемыйПериод) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, 
							НСтр("ru = 'Корректируемый период'"), 
							СтрокаТаблицы.НомерСтроки, ИмяСписка);
			Поле = Префикс + "КорректируемыйПериод"; 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
		Если СтрокаТаблицы.ВидЦенности <> Перечисления.ВидыЦенностей.ТоварыНалоговыйАгент
			И НЕ ЗначениеЗаполнено(СтрокаТаблицы.ДокументОплаты) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",,
							НСтр("ru = 'Документ оплаты'"), 
							СтрокаТаблицы.НомерСтроки, ИмяСписка);
			Поле = Префикс + "ДокументОплаты"; 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
		Если НЕ СтрокаТаблицы.ВозвратАвансовВыданных
			И НЕ ЗначениеЗаполнено(СтрокаТаблицы.СчетФактура) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",,
							НСтр("ru = 'Документ поступления'"), 
							СтрокаТаблицы.НомерСтроки, ИмяСписка);
			Поле = Префикс + "СчетФактура"; 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
	Для каждого СтрокаТаблицы Из ВычетПриИзмененииСтоимостиВСторонуУменьшения Цикл
		
		Префикс = "ВычетПриИзмененииСтоимостиВСторонуУменьшения[" + Формат(СтрокаТаблицы.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";
		ИмяСписка = НСтр("ru = 'Уменьшение стоимости реализации'");
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.Поставщик)
			И НЕ СтрокаТаблицы.ВидЦенности = Перечисления.ВидыЦенностей.СМРСобственнымиСилами Тогда
			
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, 
							НСтр("ru = 'Поставщик'"), 
							СтрокаТаблицы.НомерСтроки, ИмяСписка);
			Поле = Префикс + "Поставщик"; 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

КонецПроцедуры

#КонецЕсли

