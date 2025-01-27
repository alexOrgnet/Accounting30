﻿
#Область ПрограммныйИнтерфейс

// Процедура-обработчик нажатия навигационных ссылок в формах сверки расчета.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой есть навигационная ссылка
//  НавигационнаяСсылка - Строка 
//  СтандартнаяОбработка - признак стандартной обработки нажатия навигационной ссылки
Процедура ОбработкаНавигационнойСсылки(Форма, НавигационнаяСсылка, СтандартнаяОбработка) Экспорт

	СтандартнаяОбработка = Ложь;

	Если Не ЗначениеЗаполнено(НавигационнаяСсылка) Тогда
		Возврат;
	КонецЕсли;

	ОбщиеПараметрыНавигационныхСсылок = Форма.ПараметрыНавигационныхСсылок.ОбщиеПараметры;
	// Получаем специальные параметры навигационной ссылки с учетом кэша формы. 
	СпециальныеПараметрыНавигационнойСсылки = 
		СверкаСФНСПоИмущественнымНалогамФормыКлиентСервер.ПрочитатьСпециальныеПараметрыНавигационнойСсылки(
			Форма, 
			НавигационнаяСсылка);

	Если НавигационнаяСсылка = "СправкаРасчет" Тогда

		ОткрытьСправкуРасчет(
		    Форма,
			ОбщиеПараметрыНавигационныхСсылок.Организация,
			ОбщиеПараметрыНавигационныхСсылок.Налог,
			ОбщиеПараметрыНавигационныхСсылок.НалоговыйПериод,
			ОбщиеПараметрыНавигационныхСсылок.КодыНалоговыхОрганов);

	ИначеЕсли НавигационнаяСсылка = "РасчетНалоговой" Тогда

		Если ЗначениеЗаполнено(ОбщиеПараметрыНавигационныхСсылок.Сообщение) Тогда
			СодержаниеВложений = СверкаСФНСПоИмущественнымНалогамФормыВызовСервера.СодержаниеВложенийСообщения(
				ОбщиеПараметрыНавигационныхСсылок.Сообщение);
			Для Каждого ТекстВложения Из СодержаниеВложений Цикл
				ДокументооборотСКОКлиент.ПоказатьВходящееИзвещениеФНС(Форма, ТекстВложения);
			КонецЦикла;
		КонецЕсли;

	ИначеЕсли НавигационнаяСсылка = "РегОтчетность" Тогда

		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Раздел", ПредопределенноеЗначение("Перечисление.СтраницыЖурналаОтчетность.Входящие"));

		ОткрытьФорму("ОбщаяФорма.РегламентированнаяОтчетность",
			ПараметрыФормы,
			Форма,
			Форма.УникальныйИдентификатор);

	ИначеЕсли НавигационнаяСсылка = "ЛичныйКабинетНалогоплательщика" Тогда 
		
		ПерейтиПоНавигационнойСсылке("http://lkul.nalog.ru/");

	ИначеЕсли НавигационнаяСсылка = "КартинкаРасчетНалога" Тогда 

		ПараметрыФормы = Новый Структура;
		Если ОбщиеПараметрыНавигационныхСсылок.НалоговыйПериод >= '20220101' Тогда
			ПараметрыФормы.Вставить("Макет", "БланкРасчетаИмущественныхНалогов");
		ИначеЕсли ОбщиеПараметрыНавигационныхСсылок.ЭтоТранспортныйНалог Тогда
			ПараметрыФормы.Вставить("Макет", "БланкРасчетаТранспортногоНалога");
		ИначеЕсли ОбщиеПараметрыНавигационныхСсылок.ЭтоЗемельныйНалог Тогда
			ПараметрыФормы.Вставить("Макет", "БланкРасчетаЗемельногоНалога");
		КонецЕсли;

		ОткрытьФорму("Документ.СверкаСФНСПоИмущественнымНалогам.Форма.БланкРасчетаНалога",
			ПараметрыФормы,
			Форма,
			Форма.УникальныйИдентификатор);

	ИначеЕсли НавигационнаяСсылка = "ЗаявлениеОПередачеРасчета" Тогда

		Если Не СпециальныеПараметрыНавигационнойСсылки.Свойство("Данные") Тогда
			// Данные для заполнения новой формы. Ключ - наименование области в макете отчета.
			Данные = Новый Структура;
			Если ОбщиеПараметрыНавигационныхСсылок.ЭтоТранспортныйНалог Тогда
				Данные.Вставить("ПрСообщ", "1");
			ИначеЕсли ОбщиеПараметрыНавигационныхСсылок.ЭтоНалогНаИмущество Тогда
				Данные.Вставить("ПрСообщ", "2");
			ИначеЕсли ОбщиеПараметрыНавигационныхСсылок.ЭтоЗемельныйНалог Тогда
				Данные.Вставить("ПрСообщ", "3");
			КонецЕсли;
			Данные.Вставить("НалПериод", Формат(ОбщиеПараметрыНавигационныхСсылок.НалоговыйПериод, "ДФ=yyyy;"));
			СпециальныеПараметрыНавигационнойСсылки.Вставить("Данные", Данные);
		КонецЕсли;

		ОткрытьФормуУведомления(
		    Форма,
			ОбщиеПараметрыНавигационныхСсылок,
			НавигационнаяСсылка,
			СпециальныеПараметрыНавигационнойСсылки);

	ИначеЕсли НавигационнаяСсылка = "ПерейтиКСверке" Тогда 
	
		ОткрытьФорму("Документ.СверкаСФНСПоИмущественнымНалогам.Форма.ФормаСверки",
			Форма.ПараметрыФормыДетальнойСверки(),
			,
			Ложь);

	ИначеЕсли НавигационнаяСсылка = "ПерейтиКНастройкамОбъектов"
		 Или НавигационнаяСсылка = "ПерейтиКНастройкамОбъектовБезОтбораПоОбъекту" Тогда 
		
		Отбор = Новый Структура;
		Отбор.Вставить("Организация", ОбщиеПараметрыНавигационныхСсылок.Организация);
		
		Если ОбщиеПараметрыНавигационныхСсылок.ЭтоТранспортныйНалог Тогда
			ИмяФормыНастроек = "РегистрСведений.РегистрацияТранспортныхСредств.ФормаСписка";
		ИначеЕсли ОбщиеПараметрыНавигационныхСсылок.ЭтоЗемельныйНалог Тогда
			ИмяФормыНастроек = "РегистрСведений.РегистрацияЗемельныхУчастков.ФормаСписка";
		ИначеЕсли ОбщиеПараметрыНавигационныхСсылок.ЭтоНалогНаИмущество Тогда
			ИмяФормыНастроек = "РегистрСведений.СтавкиНалогаНаИмуществоПоОтдельнымОсновнымСредствам.ФормаСписка";
		КонецЕсли;
		
		Если НавигационнаяСсылка = "ПерейтиКНастройкамОбъектов"
			 И СпециальныеПараметрыНавигационнойСсылки <> Неопределено
			 И СпециальныеПараметрыНавигационнойСсылки.Свойство("ОтборПоОбъектам") Тогда
			Отбор.Вставить("ОсновноеСредство", СпециальныеПараметрыНавигационнойСсылки.ОтборПоОбъектам);
		КонецЕсли;
		
		ПараметрыФормы  = Новый Структура("Отбор", Отбор);
		ОткрытьФорму(ИмяФормыНастроек, ПараметрыФормы, Форма, Форма.УникальныйИдентификатор);

	ИначеЕсли НавигационнаяСсылка = "ДоплатитьНалог" Тогда

		Если СпециальныеПараметрыНавигационнойСсылки.Выполнено Тогда
			ОткрытьФорму(
				СпециальныеПараметрыНавигационнойСсылки.ИмяФормы,
				СпециальныеПараметрыНавигационнойСсылки.ПараметрыФормы,
				Форма);
		Иначе
			Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "СуммаНалогаКУплате") И
				 ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "СуммаНалогаУплачено") Тогда
				СуммаДоплаты = Форма.СуммаНалогаКУплате - Форма.СуммаНалогаУплачено; 
			Иначе
				СуммаДоплаты = 0;
			КонецЕсли;
			ОткрытьФорму(
				"Документ.ПлатежноеПоручение.ФормаОбъекта",
				СверкаСФНСПоИмущественнымНалогамФормыВызовСервера.ПараметрыФормыПлатежногоДокумента(
					ОбщиеПараметрыНавигационныхСсылок,
					СуммаДоплаты,
					Форма.Описание),
				Форма);
		КонецЕсли;

	ИначеЕсли НавигационнаяСсылка = "ДоначислитьНалог" Тогда

		Если СпециальныеПараметрыНавигационнойСсылки.Выполнено Тогда
			ОткрытьФорму(
				СпециальныеПараметрыНавигационнойСсылки.ИмяФормы,
				СпециальныеПараметрыНавигационнойСсылки.ПараметрыФормы,
				Форма);
		Иначе
			Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "СуммаНалогаКУплате") И
				 ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "СуммаНалогаУплачено") Тогда
				СуммаДоначисления = Форма.СуммаНалогаКУплате - Форма.СуммаНалогаУплачено; 
			Иначе
				СуммаДоначисления = 0;
			КонецЕсли;
			ОбрабочикПослеЗакрытия = Новый ОписаниеОповещения("ПриЗакрытииДокументаДоначисленияНалога", Форма);
			ОткрытьФорму(
				"Документ.ОперацияБух.Форма.ФормаДокумента",
				СверкаСФНСПоИмущественнымНалогамФормыВызовСервера.ПараметрыФормыБухОперации(
					ОбщиеПараметрыНавигационныхСсылок,
					СуммаДоначисления,
					Форма.Описание),
				Форма,
				,
				,
				,
				ОбрабочикПослеЗакрытия);
			КонецЕсли;

	ИначеЕсли НавигационнаяСсылка = "ЗаявлениеОЛьготе" Или НавигационнаяСсылка = "ЗаявлениеОЛьготеПоИмуществу" Тогда

		ОткрытьФормуУведомления(
		    Форма,
			ОбщиеПараметрыНавигационныхСсылок,
			НавигационнаяСсылка,
			СпециальныеПараметрыНавигационнойСсылки);

	ИначеЕсли НавигационнаяСсылка = "ЗаявлениеОГибелиТС" Тогда

		ОткрытьФормуУведомления(
		    Форма,
			ОбщиеПараметрыНавигационныхСсылок,
			НавигационнаяСсылка,
			СпециальныеПараметрыНавигационнойСсылки);

	ИначеЕсли НавигационнаяСсылка = "ПоясненияВСвязиССообщениемОРасчетеНалога" Тогда
		
		ОткрытьФорму("Отчет.РегламентированноеУведомлениеПоясненияПоСуммамНалогов.Форма.Форма2022_1", 
			ПараметрыФормыПояснений(Форма, ОбщиеПараметрыНавигационныхСсылок),
			Форма,
			Форма.УникальныйИдентификатор);

	ИначеЕсли НавигационнаяСсылка = "СообщениеОНаличииОбъектов" Тогда

		ОткрытьФормуУведомления(
			Форма,
			ОбщиеПараметрыНавигационныхСсылок,
			НавигационнаяСсылка,
			СпециальныеПараметрыНавигационнойСсылки);

	ИначеЕсли НавигационнаяСсылка = "ПерейтиКСпискуОС" Тогда

		Если ОбщиеПараметрыНавигационныхСсылок.ЭтоТранспортныйНалог Тогда
			ИмяФормыОС = "Справочник.ОсновныеСредства.Форма.ФормаСпискаТранспорт";
		ИначеЕсли ОбщиеПараметрыНавигационныхСсылок.ЭтоЗемельныйНалог Тогда
			ИмяФормыОС = "Справочник.ОсновныеСредства.Форма.ФормаСпискаЗемля";
		ИначеЕсли ОбщиеПараметрыНавигационныхСсылок.ЭтоНалогНаИмущество Тогда
			ИмяФормыОС = "Справочник.ОсновныеСредства.Форма.ФормаСпискаНедвижимость";
		КонецЕсли;

		ПараметрыФормы = Новый Структура;

		Отбор = Новый Структура;
		Отбор.Вставить("Организация", ОбщиеПараметрыНавигационныхСсылок.Организация);
		ПараметрыФормы.Вставить("Отбор", Отбор);

		ОткрытьФорму(ИмяФормыОС, ПараметрыФормы, Форма, Форма.УникальныйИдентификатор);

	КонецЕсли;

КонецПроцедуры

// Открыть справку расчет.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, из которой требуется открыть справку-расчет налога
//  Организация - СправочникСсылка.Организации 
//  НалоговыйПериод - Дата - любая дата в налоговом периоде, за который нужно открыть справку-расчет
//  КодыНалоговыхОрганов - Массив - коды налоговых органов, по которым будет отобран отчет
//
Процедура ОткрытьСправкуРасчет(Форма, Организация, Налог, НалоговыйПериод, КодыНалоговыхОрганов) Экспорт 

	Если Налог = ПредопределенноеЗначение("Перечисление.ВидыИмущественныхНалогов.ТранспортныйНалог") Тогда
		ИмяФормы = "Отчет.СправкаРасчетТранспортногоНалога.Форма";
	ИначеЕсли Налог = ПредопределенноеЗначение("Перечисление.ВидыИмущественныхНалогов.ЗемельныйНалог") Тогда
		ИмяФормы = "Отчет.СправкаРасчетЗемельногоНалога.Форма";
	ИначеЕсли Налог = ПредопределенноеЗначение("Перечисление.ВидыИмущественныхНалогов.НалогНаИмущество") Тогда
		ИмяФормы = "Отчет.СправкаРасчетНалогаНаИмущество.Форма";
	Иначе
		Возврат;
	КонецЕсли;

	ПараметрыФормыРасшифровки = Новый Структура;

	ПользовательскиеНастройки = Новый ПользовательскиеНастройкиКомпоновкиДанных;

	ПараметрыОтчета = ПользовательскиеНастройки.ДополнительныеСвойства;

	ПараметрыОтчета.Вставить("Организация",       Организация);
	ПараметрыОтчета.Вставить("ВыводитьЗаголовок", Истина);

	ПериодРасчетаНалога = СверкаСФНСПоИмущественнымНалогамФормыКлиентСервер.ПериодРасчетаНалога(НалоговыйПериод);		
	ПараметрыОтчета.Вставить("НачалоПериода", НачалоГода(ПериодРасчетаНалога));
	ПараметрыОтчета.Вставить("КонецПериода",  ПериодРасчетаНалога);	

	Отбор = ПользовательскиеНастройки.Элементы.Добавить(Тип("ОтборКомпоновкиДанных"));
	Отбор.ИдентификаторПользовательскойНастройки = "Отбор";

	СписокКодовНО = Новый СписокЗначений;
	СписокКодовНО.ЗагрузитьЗначения(КодыНалоговыхОрганов);

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		Отбор, 
		"ИФНС.Код", 
		ВидСравненияКомпоновкиДанных.ВСписке, 
		СписокКодовНО,
		,
		Истина,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);	
		
	ПараметрыФормыРасшифровки.Вставить("ВидРасшифровки", 2);
	ПараметрыФормыРасшифровки.Вставить("ПользовательскиеНастройки", ПользовательскиеНастройки);
	ЗаполняемыеНастройки = Новый Структура("Показатели, Группировка, Отбор, ВыводимыеДанные", Ложь, Истина, Истина, Ложь);
	ПараметрыФормыРасшифровки.Вставить("ЗаполняемыеНастройки", ЗаполняемыеНастройки);

	ОткрытьФорму(ИмяФормы, ПараметрыФормыРасшифровки, Форма, Форма.УникальныйИдентификатор);	

КонецПроцедуры

// Обработчик события после формирования списка расчетов из сообщения ФНС или из отдельного файла
//
// Параметры:
//  Форма							 - ФормаКлиентскогоПриложения - форма, из которой открывается сообщение или файл 
//  СписокРасчетов					 - СписокЗначений - список расчетов, содержащийся в файлах сообщения или в отдельном файле
//                                     (см. СверкаСФНСПоИмущественнымНалогамФормыВызовСервера.СписокРасчетовИзСообщения)
//  ОповещениеПослеПереходаКСверке	 - ОписаниеОповещения - оповещение, которое будет вызвано после открытия сверки
//
Процедура ПерейтиКСверкеПослеФормированияСпискаРасчетовНалога(Форма, СписокРасчетов, ОповещениеПослеПереходаКСверке = Неопределено) Экспорт 
	
	Если СписокРасчетов.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	Если СписокРасчетов.Количество() = 1 Тогда
		
		ПараметрыФормы = СписокРасчетов[0].Значение;
		ЗначенияЗаполнения = ОбщегоНазначенияКлиент.СкопироватьРекурсивно(ПараметрыФормы);
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
		ОткрытьФорму("Документ.СверкаСФНСПоИмущественнымНалогам.Форма.ФормаСверки",
			ПараметрыФормы,
			Форма,
			Ложь);
			
		Если ОповещениеПослеПереходаКСверке <> Неопределено Тогда	
			ВыполнитьОбработкуОповещения(ОповещениеПослеПереходаКСверке, Истина);
		КонецЕсли;	
			
	Иначе
			
		СписокРасчетов.ПоказатьВыборЭлемента(
			Новый ОписаниеОповещения("ПерейтиКСверкеПослеВыбораРасчета",
				ЭтотОбъект,
				Новый Структура("Форма, ОповещениеПослеПереходаКСверке", Форма, ОповещениеПослеПереходаКСверке)),
			НСтр("ru='Какой налог сверить?'"));
		
	КонецЕсли;

КонецПроцедуры

// Обработчик начала выбора файла с расчетом налога
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, из которой открывается файл с расчетом
//  Налог - ПеречислениеСсылка.ВидыИмущественныхНалогов - налог, по которому нужно открыть файл с расчетом ФНС
//          Если не указан, то может быть выбран файл с любым имущественным налогом.
//  ПериодСобытия - Дата - период события из списка задач (указаывается в том случае, если файл загружается из задачи сверки)
//  ОповещениеПослеЗагрузкиФайла - ОписаниеОповещения - оповещение, которое будет вызвано после помещения файла на сервер.
//
Процедура НачатьЗагрузкуРасчетаНалогаИзФайла(Форма, Налог = Неопределено, ПериодСобытия = '00010101', ОповещениеПослеЗагрузкиФайла) Экспорт

	ВозможныеНачалаИмениФайла = СверкаСФНСПоИмущественнымНалогамФормыКлиентСервер.ВозможныеНачалаИмениФайлаРасчета(Налог, ПериодСобытия);

	Фильтр = Новый Массив;
	ШаблонИмени = "Файл xml (%1*.xml)|%1*.xml";
	Для Каждого НачалоИмениФайла Из ВозможныеНачалаИмениФайла Цикл
		Фильтр.Добавить(СтрШаблон(ШаблонИмени, НачалоИмениФайла)); 
	КонецЦикла;
	
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.ИдентификаторФормы = Форма.УникальныйИдентификатор;
	ПараметрыЗагрузки.Диалог.Фильтр = СтрСоединить(Фильтр, "|");
	ПараметрыЗагрузки.Диалог.Заголовок = Нстр("ru='Выберите файл для загрузки расчета'");
	ПараметрыЗагрузки.Диалог.ПроверятьСуществованиеФайла = Истина;
	
	ФайловаяСистемаКлиент.ЗагрузитьФайл(ОповещениеПослеЗагрузкиФайла, ПараметрыЗагрузки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПерейтиКСверкеПослеВыбораРасчета(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	ПараметрыФормы = Результат.Значение;
	ЗначенияЗаполнения = ОбщегоНазначенияКлиент.СкопироватьРекурсивно(ПараметрыФормы);
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Документ.СверкаСФНСПоИмущественнымНалогам.Форма.ФормаСверки",
		ПараметрыФормы,
		ДополнительныеПараметры.Форма,
		Ложь);

	Если ДополнительныеПараметры.ОповещениеПослеПереходаКСверке <> Неопределено Тогда	
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПослеПереходаКСверке, Истина);
	КонецЕсли;	

КонецПроцедуры

Процедура ОткрытьФормуУведомления(Форма, ОбщиеПараметрыНавигационныхСсылок, НавигационнаяСсылка, ДополнительныеПараметры)

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация",    ОбщиеПараметрыНавигационныхСсылок.Организация);
	ПараметрыФормы.Вставить("ВидУведомления", ОбщиеПараметрыНавигационныхСсылок.УсловияПоВидуУведомления[НавигационнаяСсылка]);
	ПараметрыФормы.Вставить("РегистрацияВИФНС", ОбщиеПараметрыНавигационныхСсылок.ИФНС);

	Если ДополнительныеПараметры.Выполнено Тогда
		
		// Открываем список с отбором по виду уведомления	
		ПараметрыФормы.Вставить("Раздел", ПредопределенноеЗначение("Перечисление.СтраницыЖурналаОтчетность.Уведомления"));
		
		ОткрытьФорму("ОбщаяФорма.РегламентированнаяОтчетность",
			ПараметрыФормы,
			ЭтотОбъект,
			Форма.УникальныйИдентификатор);
			
    Иначе

		// Открываем новое уведомление
		Данные = Неопределено;
		ДополнительныеПараметры.Свойство("Данные", Данные);
		Если Данные = Неопределено Тогда
			ПараметрыФормы.Вставить("ЗаполнитьПриОткрытии", Истина);
		Иначе
			// Уведомление заполнится из структуры Данные
			ПараметрыФормы.Вставить("Данные", Данные);
		КонецЕсли;

		ОткрытьФорму("Документ.УведомлениеОСпецрежимахНалогообложения.Форма.ФормаДокумента",
			ПараметрыФормы,
			Форма,
			Форма.УникальныйИдентификатор);

	КонецЕсли;

КонецПроцедуры

Функция ПараметрыФормыПояснений(Форма, ОбщиеПараметрыНавигационныхСсылок) 

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация", ОбщиеПараметрыНавигационныхСсылок.Организация);
	ПараметрыФормы.Вставить("РегистрацияВНалоговомОргане", ОбщиеПараметрыНавигационныхСсылок.ИФНС);

	ДанныеИзвещения = УведомлениеОСпецрежимахНалогообложенияИнтеграцияКлиент.НовыеДанныеИзвещения();
	ДанныеИзвещения.ДатаДокумента = ОбщиеПараметрыНавигационныхСсылок.ДатаСообщения;
	ДанныеИзвещения.НомерДокумента = ОбщиеПараметрыНавигационныхСсылок.НомерСообщения;
	
	КатегорииТСПоКодуВида = Неопределено; // инициализируется ниже при необходимости
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ОшибкиДетально") Тогда

		НаименованиеОБъектаВИменительномПадеже = "";
		НаименованиеОБъектаВПредложномПадеже = "";
		
		Для Каждого Ошибка Из Форма.ОшибкиДетально Цикл
			
			Если ОбщиеПараметрыНавигационныхСсылок.ЭтоТранспортныйНалог Тогда
				Пояснения = УведомлениеОСпецрежимахНалогообложенияИнтеграцияКлиент.НовыеПоясненияОТранспортномСредстве();
				Пояснения.РегЗнакТС = Ошибка.РегистрационныйЗнак;
				Если ЗначениеЗаполнено(Ошибка.КодВидаТС) Тогда
					Если КатегорииТСПоКодуВида = Неопределено Тогда
						КатегорииТСПоКодуВида = СверкаСФНСПоИмущественнымНалогамФормыВызовСервера.КатегорииТСПоКодуВида();
					КонецЕсли;
					Пояснения.ВидТС = КатегорииТСПоКодуВида[Ошибка.КодВидаТС];
				КонецЕсли;
			Иначе
				Пояснения = УведомлениеОСпецрежимахНалогообложенияИнтеграцияКлиент.НовыеПоясненияОНедвижимости();
				Пояснения.НомКадастр = Ошибка.КадастровыйНомер;
			КонецЕсли;

			ТекстПояснения = Новый Массив;
			Если Не ЗначениеЗаполнено(Ошибка.ОсновноеСредство) Тогда
				НаименованиеОБъектаВИменительномПадеже = ?(ПустаяСтрока(НаименованиеОБъектаВИменительномПадеже),
					СверкаСФНСПоИмущественнымНалогамФормыВызовСервера.НаименованиеОбъектаНалогообложения(
						ОбщиеПараметрыНавигационныхСсылок.Налог,,, Истина),
					НаименованиеОБъектаВИменительномПадеже);
				Пояснение = СтрШаблон(
					Нстр("ru='%1 не принадлежит организации. Налог по объекту начисляться не должен.'"),
					НаименованиеОБъектаВИменительномПадеже);
				ТекстПояснения.Добавить(Пояснение);
			ИначеЕсли Не Ошибка.ОбъектЕстьВРасчете И ЗначениеЗаполнено(Ошибка.ДатаСнятияСУчета) Тогда
				НаименованиеОБъектаВИменительномПадеже = ?(ПустаяСтрока(НаименованиеОБъектаВИменительномПадеже),
					СверкаСФНСПоИмущественнымНалогамФормыВызовСервера.НаименованиеОбъектаНалогообложения(
						ОбщиеПараметрыНавигационныхСсылок.Налог,,, Истина),
					НаименованиеОБъектаВИменительномПадеже);
				Пояснение = СтрШаблон(
					Нстр("ru='%1 не числится в организации с %2. Налог по объекту начисляться не должен.'"),
					НаименованиеОБъектаВИменительномПадеже,
					Формат(Ошибка.ДатаСнятияСУчета, "ДЛФ=D"));
				ТекстПояснения.Добавить(Пояснение);
			ИначеЕсли Не Ошибка.ОбъектЕстьВРасчете Тогда
				НаименованиеОБъектаВИменительномПадеже = ?(ПустаяСтрока(НаименованиеОБъектаВИменительномПадеже),
					СверкаСФНСПоИмущественнымНалогамФормыВызовСервера.НаименованиеОбъектаНалогообложения(
						ОбщиеПараметрыНавигационныхСсылок.Налог,,, Истина),
					НаименованиеОБъектаВИменительномПадеже);
				Пояснение = СтрШаблон(
					Нстр("ru='%1 не числится в организации. Налог по объекту начисляться не должен.'"),
					НаименованиеОБъектаВИменительномПадеже);
				ТекстПояснения.Добавить(Пояснение);
			Иначе
				НаименованиеОБъектаВПредложномПадеже = ?(ПустаяСтрока(НаименованиеОБъектаВПредложномПадеже),
					СверкаСФНСПоИмущественнымНалогамФормыВызовСервера.НаименованиеОбъектаНалогообложения(
						ОбщиеПараметрыНавигационныхСсылок.Налог, "Предложный"),
					НаименованиеОБъектаВПредложномПадеже);
				Пояснение = СтрШаблон(
					Нстр("ru='В налоговом органе неверные сведения о %1.'"),
					НаименованиеОБъектаВПредложномПадеже);
				ТекстПояснения.Добавить(Пояснение);
				ТекстПояснения.Добавить(Символы.ПС);
				ШаблонПоказателя = Нстр("ru='%1 - %2'"); //например, "налоговая ставка - 1,5"
				Если Ошибка.Пояснения.ПравильныйРасчет.СтрокиРасчета.Количество() > 0 Тогда
					ТекстПояснения.Добавить(Нстр("ru='Правильный расчет на основании правоустанавливающих документов:'"));
					НомерСтроки = 0;
					Для каждого СтрокаРасчета Из Ошибка.Пояснения.ПравильныйРасчет.СтрокиРасчета Цикл
						НомерСтроки = НомерСтроки + 1;
						Если Ошибка.Пояснения.ПравильныйРасчет.СтрокиРасчета.Количество() > 1 Тогда
							ТекстПояснения.Добавить(Символы.ПС);
							ТекстПояснения.Добавить(Символы.ПС);
							ТекстПояснения.Добавить(СтрШаблон(Нстр("ru='Период владения %1:'"), НомерСтроки));
						КонецЕсли;
						Для каждого ПолеРасчета Из СтрокаРасчета Цикл
							ТекстПояснения.Добавить(Символы.ПС);
							НаименованияПоказателя = СверкаСФНСПоИмущественнымНалогамФормыКлиентСервер.НаименованияПоказателяРасчета(
								ПолеРасчета.Ключ);
							НаименованиеПоказателя = НаименованияПоказателя.НаименованиеВРасчете;
							ТекстПояснения.Добавить(СтрШаблон(ШаблонПоказателя, НаименованиеПоказателя, ПолеРасчета.Значение));
						КонецЦикла;
					КонецЦикла;
					ТекстПояснения.Добавить(Символы.ПС);
					ТекстПояснения.Добавить(Символы.ПС);
					ТекстПояснения.Добавить(СтрШаблон(ШаблонПоказателя, Нстр("ru='Размер налоговых льгот'"),
						Ошибка.Пояснения.ПравильныйРасчет.СуммаЛьгот));
					ТекстПояснения.Добавить(Символы.ПС);
					ТекстПояснения.Добавить(СтрШаблон(ШаблонПоказателя, Нстр("ru='Сумма исчисленного налога'"),
						Ошибка.Пояснения.ПравильныйРасчет.СуммаНалога));
				Иначе
					ТекстПояснения.Добавить(Нстр("ru='Сведения по правоустанавливающим документам:'"));
					Для каждого ПолеРасчета Из Ошибка.Пояснения.ПравильныеЗначения Цикл
						НаименованияПоказателя = СверкаСФНСПоИмущественнымНалогамФормыКлиентСервер.НаименованияПоказателяРасчета(
							ПолеРасчета.Ключ);
						НаименованиеПоказателя = НаименованияПоказателя.НаименованиеВРасчете;
						
						ТекстПояснения.Добавить(Символы.ПС);
						ТекстПояснения.Добавить(СтрШаблон(
							ШаблонПоказателя,
							НаименованиеПоказателя,
							ПолеРасчета.Значение));
						КонецЦикла;
				КонецЕсли;
			КонецЕсли;
			
			Пояснения.СодержПоясн = СтрСоединить(ТекстПояснения);
			
			Если ОбщиеПараметрыНавигационныхСсылок.ЭтоТранспортныйНалог Тогда
				ДанныеИзвещения.ПоясненияТранспортныеСредства.Добавить(Пояснения);
			Иначе
				ДанныеИзвещения.ПоясненияНедвижимость.Добавить(Пояснения);
			КонецЕсли;
			
		КонецЦикла;

	КонецЕсли;

	ПараметрыФормы.Вставить("ДанныеИзвещения", ДанныеИзвещения);

	Возврат ПараметрыФормы;

КонецФункции

#КонецОбласти
