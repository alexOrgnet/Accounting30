﻿
////////////////////////////////////////////////////////////////////////////////
// ОбменСБанкамиПереопределяемый: механизм обмена электронными документами с банками.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Заполняет массив актуальными видами электронных документов для прикладного решения.
//
// Параметры:
//  Массив - Массив из ПеречислениеСсылка.ВидыЭДОбменСБанками  - виды актуальных ЭД
//   Добавлять можно только следующие значения:
//    - Перечисления.ВидыЭДОбменСБанками.ЗапросВыписки
//    - Перечисления.ВидыЭДОбменСБанками.ПлатежноеПоручение
//    - Перечисления.ВидыЭДОбменСБанками.ПлатежноеТребование
//    - Перечисления.ВидыЭДОбменСБанками.ПоручениеНаПереводВалюты
//    - Перечисления.ВидыЭДОбменСБанками.ПоручениеНаПокупкуВалюты
//    - Перечисления.ВидыЭДОбменСБанками.ПоручениеНаПродажуВалюты
//    - Перечисления.ВидыЭДОбменСБанками.РаспоряжениеНаОбязательнуюПродажуВалюты
//    - Перечисления.ВидыЭДОбменСБанками.СписокНаЗачислениеДенежныхСредствНаСчетаСотрудников
//    - Перечисления.ВидыЭДОбменСБанками.СписокНаОткрытиеСчетовПоЗарплатномуПроекту
//    - Перечисления.ВидыЭДОбменСБанками.СписокУволенныхСотрудников
//    - Перечисления.ВидыЭДОбменСБанками.Письмо
//    - Перечисления.ВидыЭДОбменСБанками.РеестрВыплатСамозанятым
//
Процедура ПолучитьАктуальныеВидыЭД(Массив) Экспорт
	
	Массив.Добавить(Перечисления.ВидыЭДОбменСБанками.ПлатежноеПоручение);
	Массив.Добавить(Перечисления.ВидыЭДОбменСБанками.ЗапросВыписки);
	Массив.Добавить(Перечисления.ВидыЭДОбменСБанками.ПлатежноеТребование);
	Массив.Добавить(Перечисления.ВидыЭДОбменСБанками.Письмо);
	Массив.Добавить(Перечисления.ВидыЭДОбменСБанками.РеестрВыплатСамозанятым);
	Массив.Добавить(Перечисления.ВидыЭДОбменСБанками.ПоручениеНаПереводВалюты);
	
	ЗарплатаКадры.ЗаполнитьАктуальныеВидыЭД(Массив);
	
КонецПроцедуры

// Используется для получения номеров счетов в виде массив строк
//
// Параметры:
//  Организация - СправочникСсылка.Организации - отбор по организации.
//  Банк - СправочникСсылка.КлассификаторБанков - отбор по банку.
//  МассивНомеровБанковскихСчетов - Массив - Массив возврата, в элементах строки с номерами счетов.
//
Процедура ПолучитьНомераБанковскихСчетов(Организация, Банк, МассивНомеровБанковскихСчетов) Экспорт
	
	МассивНомеровБанковскихСчетов = Новый Массив;
	
	Запрос = Новый Запрос;
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	БанковскиеСчета.НомерСчета КАК НомерСчета,
	|	БанковскиеСчета.ДатаЗакрытия <> ДАТАВРЕМЯ(1, 1, 1)
	|		И БанковскиеСчета.ДатаЗакрытия <= &НачалоТекущегоДня КАК ЗакрытСейчас,
	|	БанковскиеСчета.ВыпискаЗагружаетсяПоДепозитномуСчету КАК ВыпискаЗагружаетсяПоДепозитномуСчету
	|ИЗ
	|	Справочник.БанковскиеСчета КАК БанковскиеСчета
	|ГДЕ
	|	(БанковскиеСчета.Банк = &Банк
	|			ИЛИ БанковскиеСчета.Банк.Код = &БИК)
	|	И БанковскиеСчета.Владелец = &Организация
	|	И НЕ БанковскиеСчета.ПометкаУдаления
	|	И БанковскиеСчета.Валютный = ЛОЖЬ
	|	И (БанковскиеСчета.ДатаЗакрытия = ДАТАВРЕМЯ(1, 1, 1)
	|			ИЛИ БанковскиеСчета.ДатаЗакрытия > &ТекущаяДатаПользователя)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗакрытСейчас";
	
	БИК = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Банк, "Код");
	ВозможнаЗагрузкаВалютнойВыписки = ОбменСБанками.ВозможенПрямойОбменСБанком(БИК, "3")
		Или РаботаСБанкамиБП.ВозможнаЗагрузкаВалютнойВыписки(БИК);
	Если ВозможнаЗагрузкаВалютнойВыписки Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И БанковскиеСчета.Валютный = ЛОЖЬ", "");
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("Банк",              Банк);
	Запрос.УстановитьПараметр("БИК",               БИК);
	Запрос.УстановитьПараметр("Организация",       Организация);
	Запрос.УстановитьПараметр("НачалоТекущегоДня", НачалоДня(ТекущаяДатаСеанса()));
	Запрос.УстановитьПараметр("ТекущаяДатаПользователя", ОбщегоНазначения.ТекущаяДатаПользователя());
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЭтоВалидныйРоссийскийСчет = БанковскиеПравила.ПроверитьКонтрольныйКлючВНомереБанковскогоСчета(Выборка.НомерСчета, БИК);
		Если Не ЭтоВалидныйРоссийскийСчет Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не Выборка.ВыпискаЗагружаетсяПоДепозитномуСчету
			И БанковскиеПравила.ЭтоСчетДепозитаБанка(Выборка.НомерСчета) Тогда
			Продолжить;
		КонецЕсли;
		
		МассивНомеровБанковскихСчетов.Добавить(Выборка.НомерСчета);
	КонецЦикла;
	
КонецПроцедуры

// Определяет параметры электронного документа по типу владельца.
//
// Параметры:
//  Источник - ДокументСсылка, ДокументОбъект - Источник объекта, либо ссылка документа/справочника-источника.
//  ПараметрыЭД - Структура - структура параметров источника, необходимых для определения
//                настроек обмена ЭД. Обязательные параметры: ВидЭД, Банк, Организация.
//
Процедура ЗаполнитьПараметрыЭДПоИсточнику(Источник, ПараметрыЭД) Экспорт
	
	ТипИсточника = ТипЗнч(Источник);
	
	Если ТипИсточника = Тип("ДокументСсылка.ПлатежноеПоручение")
		ИЛИ ТипИсточника = Тип("ДокументОбъект.ПлатежноеПоручение") Тогда
		
		ПараметрыЭД.ВидЭД = Перечисления.ВидыЭДОбменСБанками.ПлатежноеПоручение;
		ПараметрыЭД.Организация = Источник.Организация;
		ПараметрыЭД.Банк = Источник.СчетОрганизации.Банк;
		
	ИначеЕсли ТипИсточника = Тип("ДокументСсылка.ПлатежноеТребование")
		ИЛИ ТипИсточника = Тип("ДокументОбъект.ПлатежноеТребование") Тогда
		
		ПараметрыЭД.ВидЭД = Перечисления.ВидыЭДОбменСБанками.ПлатежноеТребование;
		ПараметрыЭД.Организация = Источник.Организация;
		ПараметрыЭД.Банк = Источник.СчетОрганизации.Банк;
		
	ИначеЕсли ТипИсточника = Тип("ДокументСсылка.ВыплатыСамозанятым")
		ИЛИ ТипИсточника = Тип("ДокументОбъект.ВыплатыСамозанятым") Тогда

		ПараметрыЭД.ВидЭД = Перечисления.ВидыЭДОбменСБанками.РеестрВыплатСамозанятым;
		Если ЗначениеЗаполнено(Источник.Организация) И ЗначениеЗаполнено(Источник.СчетОрганизации) Тогда
			ПараметрыЭД.Организация = Источник.Организация;
			ПараметрыЭД.Банк = Источник.СчетОрганизации.Банк;
		Иначе
			ДанныеПлатежногоПоручения = ОбменСБанкамиВыплатыСамозанятымСлужебный.ДанныеПлатежногоПоручения();
			ОбменСБанкамиВыплатыСамозанятымПереопределяемый.ДанныеПлатежногоПорученияРеестраВыплатСамозанятым(Источник, ДанныеПлатежногоПоручения);				
			Если ЗначениеЗаполнено(ДанныеПлатежногоПоручения) И ТипЗнч(ДанныеПлатежногоПоручения) = Тип("Структура") Тогда		
				ПараметрыЭД.Организация = ДанныеПлатежногоПоручения.Организация;
				ПараметрыЭД.Банк = ДанныеПлатежногоПоручения.Банк;						
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	ПодобратьБанкИзКлассификатора = Ложь;
	Если ТипИсточника = Тип("ДокументСсылка.ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников")
		ИЛИ ТипИсточника = Тип("ДокументОбъект.ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников") 
		ИЛИ ТипИсточника = Тип("ДокументСсылка.ВедомостьНаВыплатуЗарплатыВБанк")
		ИЛИ ТипИсточника = Тип("ДокументОбъект.ВедомостьНаВыплатуЗарплатыВБанк") 
		ИЛИ ТипИсточника = Тип("ДокументСсылка.ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудников")
		ИЛИ ТипИсточника = Тип("ДокументОбъект.ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудников") Тогда
		
		ЗарплатаКадры.ЗаполнитьПараметрыЭДПоИсточнику(Источник, ПараметрыЭД);
		Если ТипЗнч(ПараметрыЭД.Банк) = Тип("СправочникСсылка.КлассификаторБанков") Тогда
			ПодобратьБанкИзКлассификатора = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТипИсточника = Тип("СправочникСсылка.КлассификаторБанков") Тогда
		ПодобратьБанкИзКлассификатора = Истина;
	КонецЕсли;
	
	Если ПодобратьБанкИзКлассификатора Тогда
		Банки = РаботаСБанкамиБП.ПодобратьБанкИзКлассификатора(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПараметрыЭД.Банк));
		Если ЗначениеЗаполнено(Банки) Тогда
			ПараметрыЭД.Банк = Банки[Банки.ВГраница()];
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Подготавливает данные для электронного документа типа Платежное поручение.
//
// Параметры:
//  МассивСсылок - Массив - содержит ссылки на документы информационной базы, на основании которых будут созданы электронные документы.
//  ДанныеДляЗаполнения - Массив - содержит пустые деревья значений, которые необходимо заполнить данными.
//           Дерево значений повторяет структуру макета ПлатежноеПоручение из обработки ОбменСБанками.
//           Если по какому-либо документу не удалось получить данные, то текст ошибки необходимо поместить вместо дерева значений.
//           ВНИМАНИЕ! Порядок элементов массива ДанныеДляЗаполнения соответствует порядку элементов массива МассивСсылок.
//
Процедура ЗаполнитьДанныеПлатежныхПоручений(МассивСсылок, ДанныеДляЗаполнения) Экспорт
	
	ТаблицаДокументов = Обработки.КлиентБанк.ПолучитьТаблицуДокументовДляЭкспорта(МассивСсылок, Новый Массив);
	Для Каждого ПлатежноеПоручение Из ТаблицаДокументов Цикл
		
		// Порядок документов в МассивСсылок может не соответствовать порядку документов в ТаблицаДокументов,
		// поэтому из массива деревьев ДанныеДляЗаполнения данные выбираем по индексу
		ДеревоДокумента = ДанныеДляЗаполнения[МассивСсылок.Найти(ПлатежноеПоручение.Документ)];
		
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "Дата",
			ПлатежноеПоручение.Дата);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "Номер",
			УчетДенежныхСредствКлиентСервер.НомерОбъектаБезПрефикса(ПлатежноеПоручение.Номер));
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "Сумма",
			ПлатежноеПоручение.СуммаДокумента);
		
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлатежа.ВидПлатежа",
			ПлатежноеПоручение.ВидПлатежа);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлатежа.Очередность",
			ПлатежноеПоручение.ОчередностьПлатежа);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлатежа.Код",
			ПлатежноеПоручение.ИдентификаторПлатежа);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлатежа.НазначениеПлатежа",
			ПлатежноеПоручение.НазначениеПлатежа);
		
		Если ПлатежиВБюджетКлиентСервер.РеквизитЗаполнен(ПлатежноеПоручение.КодВидаДохода) Тогда
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлатежа.КодВидаДохода",
				ПлатежноеПоручение.КодВидаДохода);
		КонецЕсли;
		
		// Плательщик
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлательщика.Наименование",
			ПлатежноеПоручение.ТекстПлательщика);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлательщика.ИНН",
			ПлатежноеПоручение.ИННПлательщика);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлательщика.КПП",
			ПлатежноеПоручение.КПППлательщика);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлательщика.РасчСчет",
			ПлатежноеПоручение.ОрганизацияНомерСчета);
		
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлательщика.Банк.БИК",
			ПлатежноеПоручение.ОрганизацияБИКБанка);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлательщика.Банк.Наименование",
			ПлатежноеПоручение.ОрганизацияБанк);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлательщика.Банк.Город",
			ПлатежноеПоручение.ОрганизацияГородБанка);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлательщика.Банк.КоррСчет",
			ПлатежноеПоручение.ОрганизацияРасчСчет);
		
		// Получатель
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПолучателя.Наименование",
			ПлатежноеПоручение.ТекстПолучателя);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПолучателя.ИНН",
			ПлатежноеПоручение.ИННПолучателя);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПолучателя.КПП",
			ПлатежноеПоручение.КПППолучателя);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПолучателя.РасчСчет",
			ПлатежноеПоручение.КонтрагентНомерСчета);
		
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПолучателя.Банк.БИК",
			ПлатежноеПоручение.КонтрагентБИКБанка);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПолучателя.Банк.Наименование",
			ПлатежноеПоручение.КонтрагентБанк);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПолучателя.Банк.Город",
			ПлатежноеПоручение.КонтрагентГородБанка);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПолучателя.Банк.КоррСчет",
			ПлатежноеПоручение.КонтрагентРасчСчет);
			
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "ПлатежиВБюджет",
			ПлатежноеПоручение.ПеречислениеВБюджет);
			
		// Платежи в бюджет
		Если ПлатежноеПоручение.ПеречислениеВБюджет Тогда
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "ПлатежиВБюджет.СтатусСоставителя",
				ПлатежноеПоручение.СтатусСоставителя);
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "ПлатежиВБюджет.ПоказательКБК",
				ПлатежноеПоручение.КодБК);
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "ПлатежиВБюджет.ОКТМО",
				ПлатежноеПоручение.КодОКАТО);
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "ПлатежиВБюджет.ПоказательОснования",
				ПлатежноеПоручение.ПоказательОснования);
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "ПлатежиВБюджет.ПоказательПериода",
				ПлатежноеПоручение.ПоказательПериода);
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "ПлатежиВБюджет.ПоказательНомера",
				ПлатежноеПоручение.ПоказательНомера);
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "ПлатежиВБюджет.ПоказательДаты",
				ПлатежноеПоручение.ПоказательДаты);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ПлатежноеПоручение.КодВыплат) Тогда
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "ПлатежиВБюджет.КодВыплат",
				ПлатежноеПоручение.КодВыплат);
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

// Подготавливает данные для электронного документа типа Платежное требование.
//
// Параметры:
//  МассивСсылок - Массив - содержит ссылки на документы информационной базы, на основании которых будут созданы электронные документы.
//  ДанныеДляЗаполнения - Массив - содержит пустые деревья значений, которые необходимо заполнить данными.
//           Дерево значений повторяет структуру макета ПлатежноеТребование из обработки ОбменСБанками.
//           Если по какому-либо документу не удалось получить данные, то текст ошибки необходимо поместить вместо дерева значений.
//           ВНИМАНИЕ! Порядок элементов массива ДанныеДляЗаполнения соответствует порядку элементов массива МассивСсылок.
//
Процедура ЗаполнитьДанныеПлатежныхТребований(МассивСсылок, ДанныеДляЗаполнения) Экспорт
	
	ТаблицаДокументов = Обработки.КлиентБанк.ПолучитьТаблицуДокументовДляЭкспорта(Новый Массив, МассивСсылок);
	Для Каждого ПлатежноеТребование Из ТаблицаДокументов Цикл
		
		// Порядок документов в МассивСсылок может не соответствовать порядку документов в ТаблицаДокументов,
		// поэтому из массива деревьев ДанныеДляЗаполнения данные выбираем по индексу
		ДеревоДокумента = ДанныеДляЗаполнения[МассивСсылок.Найти(ПлатежноеТребование.Документ)];
		
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "Номер",
			ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ПлатежноеТребование.Номер, Истина, Истина));
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "Дата",
			ПлатежноеТребование.Дата);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "Сумма",
			ПлатежноеТребование.СуммаДокумента);
		
		// Плательщик (контрагент)
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлательщика.Наименование",
			ПлатежноеТребование.ТекстПлательщика);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлательщика.ИНН",
			ПлатежноеТребование.ИННПлательщика);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлательщика.КПП",
			ПлатежноеТребование.КПППлательщика);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлательщика.РасчСчет",
			ПлатежноеТребование.КонтрагентНомерСчета);
		
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлательщика.Банк.БИК",
			ПлатежноеТребование.КонтрагентБИКБанка);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлательщика.Банк.Наименование",
			ПлатежноеТребование.КонтрагентБанк);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлательщика.Банк.Город",
			ПлатежноеТребование.КонтрагентГородБанка);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлательщика.Банк.КоррСчет",
			ПлатежноеТребование.КонтрагентРасчСчет);

		// Получатель (организация)
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПолучателя.Наименование",
			ПлатежноеТребование.ТекстПолучателя);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПолучателя.ИНН",
			ПлатежноеТребование.ИННПолучателя);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПолучателя.КПП",
			ПлатежноеТребование.КПППолучателя);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПолучателя.РасчСчет",
			ПлатежноеТребование.ОрганизацияНомерСчета);
		
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПолучателя.Банк.БИК",
			ПлатежноеТребование.ОрганизацияБИКБанка);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПолучателя.Банк.Наименование",
			ПлатежноеТребование.ОрганизацияБанк);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПолучателя.Банк.Город",
			ПлатежноеТребование.ОрганизацияГородБанка);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПолучателя.Банк.КоррСчет",
			ПлатежноеТребование.ОрганизацияРасчСчет);
		
		// Реквизиты платежа
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлатежа.ВидПлатежа",
			ПлатежноеТребование.ВидПлатежа);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлатежа.Очередность",
			ПлатежноеТребование.ОчередностьПлатежа);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "РеквизитыПлатежа.НазначениеПлатежа",
			ПлатежноеТребование.НазначениеПлатежа);
		
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "УсловиеОплаты",
			Строка(ПлатежноеТребование.ВидАкцепта));
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "СрокАкцепта",
			ПлатежноеТребование.СрокАкцепта);
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, "ДатаОтсылкиДокументов",
			ПлатежноеТребование.ДатаОтсылкиДок);
		
	КонецЦикла;
	
КонецПроцедуры

// Подготавливает данные для электронного документа типа Поручение на перевод валюты.
//
// Параметры:
//  МассивСсылок - Массив - содержит ссылки на документы информационной базы, на основании которых будут созданы электронные документы.
//  ДанныеДляЗаполнения - Массив - содержит пустые деревья значений, которые необходимо заполнить данными.
//           Дерево значений повторяет структуру макета ПоручениеНаПереводВалюты из обработки ОбменСБанками.
//           Если по какому-либо документу не удалось получить данные, то текст ошибки необходимо поместить вместо дерева значений.
//           ВНИМАНИЕ! Порядок элементов массива ДанныеДляЗаполнения соответствует порядку элементов массива МассивСсылок.
//
//@skip-warning
Процедура ЗаполнитьДанныеПорученийНаПереводВалюты(МассивСсылок, ДанныеДляЗаполнения) Экспорт
	
КонецПроцедуры

// Подготавливает данные для электронного документа типа Поручение на покупку валюты.
//
// Параметры:
//  МассивСсылок - Массив - содержит ссылки на документы информационной базы, на основании которых будут созданы электронные документы.
//  ДанныеДляЗаполнения - Массив - содержит пустые деревья значений, которые необходимо заполнить данными.
//           Дерево значений повторяет структуру макета ПоручениеНаПокупкуВалюты из обработки ОбменСБанками.
//           Если по какому-либо документу не удалось получить данные, то текст ошибки необходимо поместить вместо дерева значений.
//           ВНИМАНИЕ! Порядок элементов массива ДанныеДляЗаполнения соответствует порядку элементов массива МассивСсылок.
//
//@skip-warning
Процедура ЗаполнитьДанныеПорученийНаПокупкуВалюты(МассивСсылок, ДанныеДляЗаполнения) Экспорт
	
КонецПроцедуры

// Подготавливает данные для электронного документа типа Поручение на продажу валюты.
//
// Параметры:
//  МассивСсылок - Массив - содержит ссылки на документы информационной базы, на основании которых будут созданы электронные документы.
//  ДанныеДляЗаполнения - Массив - содержит пустые деревья значений, которые необходимо заполнить данными.
//           Дерево значений повторяет структуру макета ПоручениеНаПродажуВалюты из обработки ОбменСБанками.
//           Если по какому-либо документу не удалось получить данные, то текст ошибки необходимо поместить вместо дерева значений.
//           ВНИМАНИЕ! Порядок элементов массива ДанныеДляЗаполнения соответствует порядку элементов массива МассивСсылок.
//
//@skip-warning
Процедура ЗаполнитьДанныеПорученийНаПродажуВалюты(МассивСсылок, ДанныеДляЗаполнения) Экспорт
	
КонецПроцедуры

// Подготавливает данные для электронного документа типа Распоряжение на обязательную продажу валюты.
//
// Параметры:
//  МассивСсылок - Массив - содержит ссылки на документы информационной базы, на основании которых будут созданы электронные документы.
//  ДанныеДляЗаполнения - Массив - содержит пустые деревья значений, которые необходимо заполнить данными.
//           Дерево значений повторяет структуру макета РаспоряжениеНаОбязательнуюПродажуВалюты из обработки ОбменСБанками.
//           Если по какому-либо документу не удалось получить данные, то текст ошибки необходимо поместить вместо дерева значений.
//           ВНИМАНИЕ! Порядок элементов массива ДанныеДляЗаполнения соответствует порядку элементов массива МассивСсылок.
//
//@skip-warning
Процедура ЗаполнитьДанныеРаспоряженийНаОбязательнуюПродажуВалюты(МассивСсылок, ДанныеДляЗаполнения) Экспорт
	
КонецПроцедуры

// Подготавливает данные для электронного документа типа Справка о подтверждающих документах.
//
// Параметры:
//  МассивСсылок - Массив - содержит ссылки на документы информационной базы, на основании которых будут созданы электронные документы.
//  ДанныеДляЗаполнения - Массив - содержит пустые деревья значений, которые необходимо заполнить данными.
//           Дерево значений повторяет структуру макета СправкаОПодтверждающихДокументах из обработки ОбменСБанками.
//           Если по какому-либо документу не удалось получить данные, то текст ошибки необходимо поместить вместо дерева значений.
//           ВНИМАНИЕ! Порядок элементов массива ДанныеДляЗаполнения соответствует порядку элементов массива МассивСсылок.
//
//@skip-warning
Процедура ЗаполнитьДанныеСправокОПодтверждающихДокументах(МассивСсылок, ДанныеДляЗаполнения) Экспорт
	
КонецПроцедуры

// Вызывается при получении уведомления о зачислении валюты
//
// Параметры:
//  ДеревоРазбора - ДеревоЗначений - дерево данных, соответствующее макету Обработки.ОбменСБанками.УведомлениеОЗачислении
//  НовыйДокументСсылка - ДокументСсылка - ссылка на созданный документ на основании данных электронного документа.
//
//@skip-warning
Процедура ПриПолученииУведомленияОЗачислении(ДеревоРазбора, НовыйДокументСсылка) Экспорт
	
КонецПроцедуры

// Включает тестовый режим обмена в банком.
// При включении тестового режима возможно ручное указание URL сервера для получения настроек обмена.
//
// Параметры:
//    ИспользуетсяТестовыйРежим - Булево - признак использования тестового режима.
//
Процедура ПроверитьИспользованиеТестовогоРежима(ИспользуетсяТестовыйРежим) Экспорт
	
	Если Найти(ВРег(Константы.ЗаголовокСистемы.Получить()), ВРег("DirectBank")) > 0 Тогда
		
		ИспользуетсяТестовыйРежим = Истина;
		
	КонецЕсли;

КонецПроцедуры

// Событие возникает при получении выписки из регламентного задания или при синхронизации.
// Необходимо создать документы в информационной базе для отражения произведенных по счету операций.
// Для получения данных выписки в удобном формате можно использовать следующие процедуры:
//  - ОбменСБанками.ПолучитьДанныеВыпискиБанкаДеревоЗначений()
//  - ОбменСБанками.ПолучитьДанныеВыпискиБанкаТекстовыйФормат() - только для рублевых выписок.
//
// Параметры:
//  СообщениеОбмена - ДокументСсылка.СообщениеОбменСБанками - ссылка на сообщение обмена, содержащий выписку банка.
//
Процедура ПриПолученииВыписки(СообщениеОбмена) Экспорт
	
	АдресХранилища = "";
	УникальныйИдентификатор = Новый УникальныйИдентификатор();
	
	Выписки = Новый Массив;
	Выписки.Добавить(СообщениеОбмена);
	АдресВыписки = ЭлектронноеВзаимодействиеБПВызовСервера.ДанныеВыписокБанкаВКоллекцию(Выписки);
	
	МассивСчетов = Новый Массив;
	ВыпискаБанка = ЭлектронноеВзаимодействиеБПВызовСервера.ПрочитанныеДанныеСервиса(Выписки, МассивСчетов);
	
	Если ВыпискаБанка.ДанныеИзБанка.Документы.Количество() = 0 Тогда
		Результат = Новый Структура;
		Результат.Вставить("Статус", "Ошибка");
		Результат.Вставить("КраткоеПредставлениеОшибки",   "");
		Результат.Вставить("ПодробноеПредставлениеОшибки", "");
		Возврат;
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	
	СтруктураПараметров.Вставить("АдресХранилищаРаспознанныеДанныеИзБанка",
		ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор));
	СтруктураПараметров.Вставить("Кодировка",    Неопределено);
	СтруктураПараметров.Вставить("ВыпискаБанка", ВыпискаБанка);
	
	СведенияОВладельцеБанковскогоСчетаИзКонтекста = Новый Структура;
	СведенияОВладельцеБанковскогоСчетаИзКонтекста.Вставить("Организация",               Новый Массив);
	СведенияОВладельцеБанковскогоСчетаИзКонтекста.Вставить("БанковскийСчетОрганизации", Новый Массив);
	Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СообщениеОбмена, "Организация");
	СведенияОВладельцеБанковскогоСчетаИзКонтекста.Организация.Добавить(Организация);
	СтруктураПараметров.Вставить("СведенияОВладельцеБанковскогоСчетаИзКонтекста", СведенияОВладельцеБанковскогоСчетаИзКонтекста);
	
	ИнтеграцияВИнформационнойБазеВключена = ИнтеграцияСБанкамиПовтИсп.ИнтеграцияВИнформационнойБазеВключена();
	ИнтеграцияСБанкамиПодключена = ИнтеграцияВИнформационнойБазеВключена
		И ОбщегоНазначенияБП.ЭтоИнтерфейсИнтеграцииСБанком();
	Если ИнтеграцияСБанкамиПодключена Тогда
	СчетаБезИнтеграции = Справочники.НастройкиИнтеграцииСБанками.БанковскиеСчетаОрганизацииБезИнтеграции(Организация);
	ЕстьБанковскиеСчетаБезИнтеграции = СчетаБезИнтеграции.Количество() <> 0;
	Если ЕстьБанковскиеСчетаБезИнтеграции Тогда
		СтруктураПараметров.Вставить("РежимИнтеграцииОграничиватьПериодВыписки", Истина);
	КонецЕсли;
	КонецЕсли;
		
	Обработки.КлиентБанк.ФоноваяЗагрузкаБанковскойВыпискиИзЖурнала(СтруктураПараметров, АдресХранилища, Истина);
	
КонецПроцедуры

// Вызывается однократно при первом формировании списка команд, выводимых в форме конкретного объекта конфигурации.
// Возможно изменение значений структуры в параметре Команды. Например, можно добавить условие видимости команды.
//
// Параметры:
//   НастройкиФормы - Структура - см. ПодключаемыеКомандыПереопределяемый.ПриОпределенииКомандПодключенныхКОбъекту
//   Источники - ДеревоЗначений - см. ПодключаемыеКомандыПереопределяемый.ПриОпределенииКомандПодключенныхКОбъекту
//   ПодключенныеОтчетыИОбработки - см.ПодключаемыеКомандыПереопределяемый.ПриОпределенииКомандПодключенныхКОбъекту
//   Команды - ФиксированнаяСтруктура - команды, добавленные подсистемой ОбменСБанками.
//   	* Ключ - Строка - Идентификатор добавленной команды. Может содержать следующие значения:
//   		"ДиректБанкОтправка", "ДиректБанкПросмотр", "ДиректБанкСоздать", "ДиректБанкСписок", "ДиректБанкВыписки",
//   		"ДиректБанкПисьма"
//   	* Значение - СтрокаТаблицыЗначений - структура таблицы описана
//          в ПодключаемыеКомандыПереопределяемый.ПриОпределенииКомандПодключенныхКОбъекту
//@skip-warning пустая процедура в БЭД
Процедура ПриОпределенииКомандДиректБанк(НастройкиФормы, Источники, ПодключенныеОтчетыИОбработки, Команды) Экспорт
	
	ОбменСБанкамиБЗК.ПриОпределенииКомандДиректБанк(НастройкиФормы, Источники, ПодключенныеОтчетыИОбработки, Команды);
	
КонецПроцедуры

#Область ПроцедурыИФункцииСтатусовДокумента

// Для выполнения действий после отправки электронных документов в прикладной конфигурации
//
// Параметры:
//   РезультатОтправки - Структура - результат выполнения предыдущей процедуры СформироватьИОтправитьПакетыВБанк
//     * КоличествоПодготовленных - Число - количество подготовленных документов
//     * ОтправленныеДокументы - Массив - содержит ссылки на документы, которые были отправлены
//     * ОтправленныеСообщенияОбмена - Массив - содержит ссылки на ДокументСсылка.СообщениеОбменСБанками, которые были отправлены
//
Процедура ПослеОтправкиЭД(РезультатОтправки) Экспорт

	// Назначим документу "Выплаты самозанятым" статус "Отправлено"
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СообщениеОбменСБанками.Ссылка КАК Ссылка,
	|	ЕСТЬNULL(СвязанныеОбъектыОбменСБанками.СсылкаНаОбъект, ЗНАЧЕНИЕ(Документ.ВыплатыСамозанятым.ПустаяСсылка)) КАК СсылкаНаОбъект
	|ИЗ
	|	Документ.СообщениеОбменСБанками КАК СообщениеОбменСБанками
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СвязанныеОбъектыОбменСБанками КАК СвязанныеОбъектыОбменСБанками
	|		ПО СообщениеОбменСБанками.Ссылка = СвязанныеОбъектыОбменСБанками.СообщениеОбмена
	|ГДЕ
	|	СообщениеОбменСБанками.ВидЭД = &ВидЭД
	|	И СообщениеОбменСБанками.Статус = &Статус
	|	И СообщениеОбменСБанками.Ссылка В(&ОтправленныеСообщенияОбмена)
	|	И СвязанныеОбъектыОбменСБанками.СсылкаНаОбъект ССЫЛКА Документ.ВыплатыСамозанятым";
	Запрос.УстановитьПараметр("ВидЭД", Перечисления.ВидыЭДОбменСБанками.РеестрВыплатСамозанятым);
	Запрос.УстановитьПараметр("Статус", Перечисления.СтатусыОбменСБанками.Отправлен);
	Запрос.УстановитьПараметр("ОтправленныеСообщенияОбмена", РезультатОтправки.ОтправленныеСообщенияОбмена);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл		
		НовыеСтатусыДокумента = РегистрыСведений.СтатусыДокументов.НовыеСтатусыДокумента();
		НовыеСтатусыДокумента.Статус = Перечисления.СтатусыДокументовВыплатыСамозанятым.Отправлено;
		РегистрыСведений.СтатусыДокументов.УстановитьСтатусыДокумента(Выборка.СсылкаНаОбъект, НовыеСтатусыДокумента);
	КонецЦикла;
	
КонецПроцедуры

// Проверяет доступность функциональности отправки почтовых сообщений 
//
// Параметры:
//   ЭлектроннаяПочтаПоддерживается - Булево
//
Процедура ПроверитьДоступностьФункциональностиЭлектроннойПочты(ЭлектроннаяПочтаПоддерживается) Экспорт
	
	ЭлектроннаяПочтаПоддерживается = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ЗарплатныйПроект

// Вызывается для формирования XML файла в прикладном решении.
//
// Параметры:
//    ОбъектДляВыгрузки - ДокументСсылка - ссылка на документ, на основании которого будет сформирован ЭД.
//    ИмяФайла - Строка - имя сформированного файла.
//    АдресФайла - Строка - АдресВременногоХранилища, содержит двоичные данные файла.
//
//@skip-warning
Процедура ПриФормированииXMLФайла(ОбъектДляВыгрузки, ИмяФайла, АдресФайла) Экспорт
	
	ЗарплатаКадры.ПриФормированииXMLФайла(ОбъектДляВыгрузки, ИмяФайла, АдресФайла);
	
КонецПроцедуры

// Формирует табличный документ на основании файла XML для визуального отображения электронного документа.
//
// Параметры:
//  ИмяФайла - Строка - полный путь к файлу XML
//  ТабличныйДокумент - ТабличныйДокумент - возвращаемое значение, визуальное отображение данных файла.
//
//@skip-warning
Процедура ЗаполнитьТабличныйДокумент(Знач ИмяФайла, ТабличныйДокумент) Экспорт
	
	ЗарплатаКадры.ЗаполнитьТабличныйДокументПоПрямомуОбменуСБанками(ИмяФайла, ТабличныйДокумент);
	
КонецПроцедуры

// Вызывается при получении файла из банка.
//
// Параметры:
//  АдресДанныхФайла - Строка - адрес временного хранилища с двоичными данными файла.
//  ИмяФайла - Строка - формализованное имя файла данных.
//  ОбъектВладелец - ДокументСсылка - (возвращаемый параметр) ссылка на документ, который был создан на основании ЭД.
//  ДанныеОповещения - Структура - (возвращаемый параметр) данные для вызова метода Оповестить на клиенте.
//                 * Ключ - Строка - имя события.
//                 * Значение - Произвольный - параметр сообщения.
//@skip-warning
Процедура ПриПолученииXMLФайла(АдресДанныхФайла, ИмяФайла, ОбъектВладелец, ДанныеОповещения) Экспорт
	
	ЗарплатаКадры.ПриПолученииXMLФайла(АдресДанныхФайла, ИмяФайла, ОбъектВладелец, ДанныеОповещения);
	
КонецПроцедуры

// Вызывается при изменении состояния электронного документооборота.
//
// Параметры:
//  СсылкаНаОбъект - ДокументСсылка - владелец электронного документооборота;
//  СостояниеЭД - ПеречислениеСсылка.СостоянияОбменСБанками - новое состояние электронного документооборота.
//
//@skip-warning
Процедура ПриИзмененииСостоянияЭД(СсылкаНаОбъект, СостояниеЭД) Экспорт
	
	СостояниеСтрокой = ЭлектронноеВзаимодействиеБП.СостояниеБанковскогоДокументаСтрокой(СостояниеЭД, СсылкаНаОбъект);
	РегистрыСведений.СостоянияБанковскихДокументов.УстановитьСостояниеДокумента(СсылкаНаОбъект, СостояниеСтрокой);
	
КонецПроцедуры

#КонецОбласти

// Позволяет скорректировать входящие параметры перед обработкой электронных документов.
//
// Параметры:
//  Параметры - Структура - параметры обработки электронных документов, содержит поля:
//   * МассивСсылокНаОбъект - Массив - содержит ссылки на документы, которые необходимо обработать;
//   * МассивОтпечатковСертификатов - Массив - отпечатки доступных сертификатов на клиенте;
//   * Действия - Строка - последовательность необходимых действий с электронным документом;
//   * СообщениеОбмена - ДокументСсылка.СообщениеОбменСБанками - ссылка сообщение обмена, который нужно обработать;
//   * СессииОбменСБанками - Соответствие - существующие сессии обмена со Сбербанком
//                         - Неопределено - нет установленных сессий.
//   * Фрод - Структура - содержит адреса сетевого оборудования клиента: 
//   	** MAC - Массив из Строка - MAC адреса сетевого оборудования клиента.
//   	** IP - Массив из Строка - IP адреса сетевого оборудования клиента.
//   	** IPАдресКлиента - Строка - IP адрес клиента с точки зрения сервера.
//
Процедура ПередОбработкойЭлектронныхДокументов(Параметры) Экспорт

	// Для данной конфигурации процедура позволяет  добавить в массив выгружаемых документов связанный документ.
	// Для того, чтобы параллельно с платежным поручением отправить в банк Реестр выплат самозанятым,
	//  и только в том случае, если до этого Реестр выплат уже не был отправлен отдельно.
			
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ПлатежноеПоручение.РеестрВыплатСамозанятым КАК РеестрВыплатСамозанятым,
	|	ЕСТЬNULL(СостоянияОбменСБанками.СообщениеОбмена, ЗНАЧЕНИЕ(Документ.СообщениеОбменСБанками.ПустаяСсылка)) КАК СообщениеОбмена
	|ИЗ
	|	Документ.ПлатежноеПоручение КАК ПлатежноеПоручение
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияОбменСБанками КАК СостоянияОбменСБанками
	|		ПО ПлатежноеПоручение.РеестрВыплатСамозанятым = СостоянияОбменСБанками.СсылкаНаОбъект
	|ГДЕ
	|	ПлатежноеПоручение.Ссылка В(&МассивДокументов)
	|	И ПлатежноеПоручение.РеестрВыплатСамозанятым <> ЗНАЧЕНИЕ(Документ.ВыплатыСамозанятым.ПустаяСсылка)
	|	И ПлатежноеПоручение.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийСписаниеДенежныхСредств.ВыплатыСамозанятым)
	|	И ЕСТЬNULL(СостоянияОбменСБанками.СообщениеОбмена, ЗНАЧЕНИЕ(Документ.СообщениеОбменСБанками.ПустаяСсылка)) = ЗНАЧЕНИЕ(Документ.СообщениеОбменСБанками.ПустаяСсылка)";
	Запрос.УстановитьПараметр("МассивДокументов", Параметры.МассивСсылокНаОбъект);	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Параметры.МассивСсылокНаОбъект.Добавить(Выборка.РеестрВыплатСамозанятым);
	КонецЦикла;
	
КонецПроцедуры

// Процедура добавляет связанные документы для прикладной конфигурации
//
// Параметры:
//    ТекущийДокумент - ДокументСсылка - ссылка на документ, для которого нужно добавить связанный документ.
//    МассивДокументов - Массив из ДокументСсылка - массив документов, в который необходимо добавить 
//      связанные документы для прикладной конфигурации.
//
Процедура ДобавитьСвязанныеДокументы(ТекущийДокумент, МассивДокументов) Экспорт
	
	Если ТипЗнч(ТекущийДокумент) = Тип("ДокументСсылка.ВыплатыСамозанятым") Тогда
		Запрос = Новый Запрос;
		ТекстЗапроса =
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ПлатежноеПоручение.Ссылка КАК Ссылка,
			|	ПлатежноеПоручение.Дата КАК Дата
			|ИЗ
			|	Документ.ПлатежноеПоручение КАК ПлатежноеПоручение
			|ГДЕ
			|	ПлатежноеПоручение.РеестрВыплатСамозанятым = &РеестрВыплатСамозанятым
			|	И ПлатежноеПоручение.Проведен
			|	И ПлатежноеПоручение.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийСписаниеДенежныхСредств.ВыплатыСамозанятым)
			|
			|УПОРЯДОЧИТЬ ПО
			|	ПлатежноеПоручение.Дата УБЫВ";    
		Запрос.Текст = ТекстЗапроса;
		Запрос.УстановитьПараметр("РеестрВыплатСамозанятым", ТекущийДокумент);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда                                                                  
			МассивДокументов.Добавить(Выборка.Ссылка);
			МассивДокументов.Добавить(ТекущийДокумент);
		КонецЕсли;
	КонецЕсли;
	Если ТипЗнч(ТекущийДокумент) = Тип("ДокументСсылка.ПлатежноеПоручение") Тогда
		Запрос = Новый Запрос;
		ТекстЗапроса =
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ПлатежноеПоручение.РеестрВыплатСамозанятым КАК РеестрВыплатСамозанятым,
			|	ПлатежноеПоручение.Дата КАК Дата
			|ИЗ
			|	Документ.ПлатежноеПоручение КАК ПлатежноеПоручение
			|ГДЕ
			|	ПлатежноеПоручение.Ссылка = &Ссылка
			|	И ПлатежноеПоручение.Проведен
			|	И ПлатежноеПоручение.РеестрВыплатСамозанятым <> ЗНАЧЕНИЕ(Документ.ВыплатыСамозанятым.ПустаяСсылка)
			|	И ПлатежноеПоручение.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийСписаниеДенежныхСредств.ВыплатыСамозанятым)
			|
			|УПОРЯДОЧИТЬ ПО
			|	ПлатежноеПоручение.Дата УБЫВ";
		Запрос.Текст = ТекстЗапроса;
		Запрос.УстановитьПараметр("Ссылка", ТекущийДокумент);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда                                                                  
			МассивДокументов.Добавить(ТекущийДокумент);
			МассивДокументов.Добавить(Выборка.РеестрВыплатСамозанятым);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
