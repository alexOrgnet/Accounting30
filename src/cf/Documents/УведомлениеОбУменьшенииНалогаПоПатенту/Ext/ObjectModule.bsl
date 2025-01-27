﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата          = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();
	Уведомление   = Документы.УведомлениеОСпецрежимахНалогообложения.ПустаяСсылка();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Проверка уникальности записей в документе
	ТаблицаПатенты = Патенты.Выгрузить();
	КолонкиСверки = "ДокументПатент";
	ТаблицаПатенты.Свернуть(КолонкиСверки);
	Если ТаблицаПатенты.Количество() <> Патенты.Количество() Тогда
		ОтборСтрок = Новый Структура(КолонкиСверки);
		Для Каждого СтрокаТаблицы Из ТаблицаПатенты Цикл
			
			ЗаполнитьЗначенияСвойств(ОтборСтрок, СтрокаТаблицы);
			МассивСтрок = Патенты.НайтиСтроки(ОтборСтрок);
			Если МассивСтрок.Количество() = 1 Тогда
				Продолжить;
			КонецЕсли;
			
			НомераСтрок = "";
			Для Каждого СтрокаМассива Из МассивСтрок Цикл
				НомераСтрок = НомераСтрок + ?(НомераСтрок <> "", ", ", "") + СтрокаМассива.НомерСтроки;
			КонецЦикла;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Дублируется ключевое значение ""Патент"" в строках %1'"),
				НомераСтрок);
				
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,
				,
				"Патенты",
				"Объект",
				Отказ);
			
		КонецЦикла;
	КонецЕсли;
	
	// Проверка суммы расхода документа 
	СуммаИзТабличнойЧасти = Патенты.Итог("Сумма") + Патенты.Итог("СуммаУменьшеноРанее");
	Если СуммаИзТабличнойЧасти > СуммаРасходов Тогда
		ТекстСообщения = НСтр("ru = 'Сумма уменьшения не может быть больше, чем всего расходов'");
			
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,
			,
			"Патенты",
			"Объект",
			Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// При групповом перепроведении реквизиты документов не меняются,
	// поэтому обновление связанных данных выполнять не требуется.
	Если ПроведениеСервер.ГрупповоеПерепроведение(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("СинхронизацияСостоянийУведомлений") Тогда
		Возврат;
	КонецЕсли;
	
	АктуализироватьУведомлениеОСпецрежимахНалогообложения();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// При групповом перепроведении реквизиты документов не меняются,
	// поэтому обновление связанных данных выполнять не требуется.
	Если ПроведениеСервер.ГрупповоеПерепроведение(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	УчетПСН.СинхронизироватьСостояниеУведомлений(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.УведомлениеОбУменьшенииНалогаПоПатенту.ПодготовитьПараметрыПроведения(
		Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ
	
	// Таблица уменьшения налога
	ТаблицаУменьшенияНалога = УчетПСН.ПодготовитьТаблицуУменьшенияНалога(
		ПараметрыПроведения.Реквизиты, ПараметрыПроведения.ТаблицаПатенты);
	
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	
	// Данные по уменьшению налога
	УчетПСН.СформироватьДвиженияПоУменьшениюНалога(
		ПараметрыПроведения.Реквизиты,
		ПараметрыПроведения.ТаблицаПатенты,
		Движения,
		Отказ);
	
	// Бухгалтерский учет
	УчетПСН.СформироватьПроводкиПоНалогу(
		ПараметрыПроведения.Реквизиты,
		ТаблицаУменьшенияНалога,
		Движения,
		Отказ);
	
	ПроведениеСервер.УстановитьЗаписьОчищаемыхНаборовЗаписей(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
	
	РаботаСПоследовательностями.ОтменитьРегистрациюВПоследовательности(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТребуетсяАктуализация()
	
	ТребуетсяАктуализация = Ложь;
	Если Ссылка.Пустая() Или ДополнительныеСвойства.Свойство("Актуализировать") Тогда
		ТребуетсяАктуализация = Истина;
	Иначе
		ОбъектДоИзменения    = Ссылка.ПолучитьОбъект();
		ОбъектПослеИзменения = ЭтотОбъект;
		СуммаДокументаДоИзменения = ОбъектДоИзменения.Патенты.Итог("Сумма");
		СуммаДокументаПослеИзменения = ОбъектПослеИзменения.Патенты.Итог("Сумма");
		Если ОбъектДоИзменения.Дата <> ОбъектПослеИзменения.Дата
			Или ОбъектДоИзменения.Комментарий <> ОбъектПослеИзменения.Комментарий
			Или ОбъектДоИзменения.НалоговыйОрган <> ОбъектПослеИзменения.НалоговыйОрган
			Или ОбъектДоИзменения.СуммаРасходов <> ОбъектПослеИзменения.СуммаРасходов
			Или СуммаДокументаДоИзменения <> СуммаДокументаПослеИзменения
			Или ОбъектДоИзменения.Патенты.Количество() <> ОбъектПослеИзменения.Патенты.Количество() Тогда
			ТребуетсяАктуализация = Истина;
		Иначе
			СписокКолонок = Метаданные().ТабличныеЧасти.Патенты.Реквизиты;
			Для ИндексСтроки = 0 По ОбъектДоИзменения.Патенты.Количество() - 1 Цикл
				СтрокаДоИзменения    = ОбъектДоИзменения.Патенты[ИндексСтроки];
				СтрокаПослеИзменения = ОбъектПослеИзменения.Патенты[ИндексСтроки];
				Для Каждого Колонка Из СписокКолонок Цикл
					Если СтрокаДоИзменения[Колонка.Имя] <> СтрокаПослеИзменения[Колонка.Имя] Тогда
						ТребуетсяАктуализация = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ТребуетсяАктуализация;
	
КонецФункции

Процедура АктуализироватьУведомлениеОСпецрежимахНалогообложения()
	
	Если Не ТребуетсяАктуализация() Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		СсылкаОбъекта = Документы.УведомлениеОбУменьшенииНалогаПоПатенту.ПолучитьСсылку();
		УстановитьСсылкуНового(СсылкаОбъекта);
	Иначе
		СсылкаОбъекта = Ссылка;
	КонецЕсли;
	
	ПараметрыУведомления = Новый Структура;
	ПараметрыУведомления.Вставить("Организация", Организация);
	ПараметрыУведомления.Вставить("РегистрацияВИФНС", НалоговыйОрган);
	ПараметрыУведомления.Вставить("Период", ГодДействияПатентов());
	ПараметрыУведомления.Вставить("ДокументОснование", СсылкаОбъекта);
	ПараметрыУведомления.Вставить("КомментарийОснования", Комментарий);
	Если ЗначениеЗаполнено(Уведомление)
		И ОбщегоНазначения.СсылкаСуществует(Уведомление) Тогда
		ПараметрыУведомления.Вставить("СсылкаНаУведомление", Уведомление);
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ДанныеПомощника")
		И ТипЗнч(ДополнительныеСвойства.ДанныеПомощника) = Тип("Структура")
		И ДополнительныеСвойства.ДанныеПомощника.Свойство("Патенты") Тогда
		ДанныеПомощника = ДополнительныеСвойства.ДанныеПомощника;
		ТаблицаПатентов = ДанныеПомощника.Патенты.Получить();
		ОбработатьИзменениеДанныхПоПатентам(ТаблицаПатентов);
		ПараметрыУведомления.Вставить("ЗаполненоПоДаннымПомощника");
	Иначе
		ТаблицаПатентов = ТаблицаСведенийПоПатентам();
	КонецЕсли;
	
	Ключ = Новый УникальныйИдентификатор;
	ДанныеЗаполнения = УчетПСН.ДанныеЗаполненияУведомленияОбУменьшенииНалогаНаСтраховыеВзносы_Форма2021(
		ПараметрыУведомления, ТаблицаПатентов, СуммаРасходов, Ключ);
	
	ПараметрыУведомления.Вставить("ДанныеЗаполнения", ДанныеЗаполнения);
	
	Уведомление = 
		Отчеты.РегламентированноеУведомлениеУменьшениеНалогаНаСтраховыеВзносы.СформироватьНовоеУведомление(ПараметрыУведомления);
	
КонецПроцедуры

Процедура ОбработатьИзменениеДанныхПоПатентам(ТаблицаПатентов)
	
	Если Не ЗначениеЗаполнено(ТаблицаПатентов) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаПатент Из Патенты Цикл
		
		СтрокаТаблицыПатентов = ТаблицаПатентов.Найти(СтрокаПатент.ДокументПатент, "ДокументПатент");
		
		Если СтрокаТаблицыПатентов <> Неопределено Тогда
			СтрокаТаблицыПатентов.Уменьшить = СтрокаПатент.Сумма;
		Иначе
			ДанныеПатента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтрокаПатент.ДокументПатент,
				"Патент, НомерПатента, ДатаВыдачи, ДатаНачала, ДатаОкончания, СуммаПервогоПлатежа, СуммаВторогоПлатежа,
				|ДатаПервогоПлатежа, ДатаВторогоПлатежа, ПотенциальноВозможныйГодовойДоход");
			
			СтрокаТаблицыПатентов = ТаблицаПатентов.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТаблицыПатентов, ДанныеПатента);
			СтрокаТаблицыПатентов.Ссылка = ДанныеПатента.Патент;
			СтрокаТаблицыПатентов.ДокументПатент = СтрокаПатент.ДокументПатент;
			СтрокаТаблицыПатентов.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеПатента.Патент, "Наименование");
			СтрокаТаблицыПатентов.СуммаКОплате = ДанныеПатента.СуммаПервогоПлатежа + ДанныеПатента.СуммаВторогоПлатежа;
			СтрокаТаблицыПатентов.Уменьшить = СтрокаПатент.Сумма;
		КонецЕсли;
		
		СведенияОбУменьшенииНалога = РегистрыСведений.УменьшениеНалогаПоПатенту.СведенияУменьшениеНалогаЗаГод(
			Организация, Дата, СтрокаПатент.ДокументПатент, Уведомление);
		ДанныеУменьшения = СведенияОбУменьшенииНалога.Получить(СтрокаПатент.ДокументПатент);
		
		Если ДанныеУменьшения <> Неопределено Тогда
			СтрокаТаблицыПатентов.УменьшеноРанее = ДанныеУменьшения.Сумма;
			СтрокаТаблицыПатентов.Уведомления = ДанныеУменьшения.Уведомления;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ТаблицаСведенийПоПатентам()
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Патенты", Патенты.Выгрузить());
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Патенты.ДокументПатент КАК ДокументПатент,
	|	Патенты.СуммаУменьшеноРанее КАК УменьшеноРанее,
	|	Патенты.Сумма КАК Уменьшить
	|ПОМЕСТИТЬ ВТ_Патенты
	|ИЗ
	|	&Патенты КАК Патенты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Патенты.Ссылка КАК Ссылка,
	|	Патенты.Наименование КАК Наименование,
	|	ВТ_Патенты.ДокументПатент КАК ДокументПатент,
	|	ОперацияСПатентом.ДатаНачала КАК ДатаНачала,
	|	ОперацияСПатентом.ДатаОкончания КАК ДатаОкончания,
	|	ОперацияСПатентом.СуммаПервогоПлатежа + ОперацияСПатентом.СуммаВторогоПлатежа КАК СуммаКОплате,
	|	ОперацияСПатентом.НомерПатента КАК НомерПатента,
	|	ОперацияСПатентом.ДатаВыдачи КАК ДатаВыдачи,
	|	ВТ_Патенты.УменьшеноРанее КАК УменьшеноРанее,
	|	ВТ_Патенты.Уменьшить КАК Уменьшить
	|ИЗ
	|	ВТ_Патенты КАК ВТ_Патенты
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОперацияСПатентом КАК ОперацияСПатентом
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Патенты КАК Патенты
	|			ПО ОперацияСПатентом.Патент = Патенты.Ссылка
	|		ПО ВТ_Патенты.ДокументПатент = ОперацияСПатентом.Ссылка";
	
	ТаблицаПатенты = Запрос.Выполнить().Выгрузить();
	
	ТаблицаПатенты.Колонки.Добавить("Уведомления");
	
	СведенияОбУменьшенииНалога = РегистрыСведений.УменьшениеНалогаПоПатенту.СведенияУменьшениеНалогаЗаГод(
		Организация, Дата, , Уведомление);
		
	Для Каждого ДанныеУменьшения Из СведенияОбУменьшенииНалога Цикл
		Строка = ТаблицаПатенты.Найти(ДанныеУменьшения.Ключ, "ДокументПатент");
		Если Строка <> Неопределено Тогда
			Строка.УменьшеноРанее = ДанныеУменьшения.Значение.Сумма;
			Строка.Уведомления = ДанныеУменьшения.Значение.Уведомления;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТаблицаПатенты;
	
КонецФункции

Функция ГодДействияПатентов()
	
	// Определим год действия патентов согласно сроку
	// В одном уведомлении не могут быть патенты разных годов
	
	Патент = Патенты[0].ДокументПатент;
	
	ДатаОкончанияСрокаДействия = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Патент, "ДатаОкончания");
	
	Возврат КонецГода(ДатаОкончанияСрокаДействия);
	
КонецФункции

#КонецОбласти

#КонецЕсли