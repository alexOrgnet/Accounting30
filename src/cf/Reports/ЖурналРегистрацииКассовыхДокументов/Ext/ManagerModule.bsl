﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура СформироватьОтчет(Знач ПараметрыОтчета, АдресХранилища) Экспорт
	
	ПараметрыОтчета.СписокСформированныхЛистов.Очистить();
	
	СформироватьЖурналКассовыхДокументов(ПараметрыОтчета);
	СформироватьОбложкуЖурналаКассовыхДокументов(ПараметрыОтчета);
	
	ПоместитьВоВременноеХранилище(ПараметрыОтчета.СписокСформированныхЛистов, АдресХранилища);
	
КонецПроцедуры

Процедура СформироватьОбложкуЖурналаКассовыхДокументов(ПараметрыОтчета)
	
	Обложка = Новый ТабличныйДокумент;
	
	Обложка.Очистить();
	
	СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ПараметрыОтчета.Организация, КонецДня(ПараметрыОтчета.КонецПериода));
	ПредставлениеОрганизации = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "НаименованиеДляПечатныхФорм,");
	Руководители = ОтветственныеЛицаБП.ОтветственныеЛица(ПараметрыОтчета.Организация, КонецДня(ПараметрыОтчета.КонецПериода));
	
	Макет = ПолучитьМакет("Обложка");
	ОбластьОбложка = Макет.ПолучитьОбласть("Обложка");
	
	ОбластьОбложка.Параметры.НазваниеОрганизации = ПредставлениеОрганизации;
	ОбластьОбложка.Параметры.НадписьОбложка = " на "+Формат(ПараметрыОтчета.КонецПериода, "ДФ=yyyy") + " г.";
	ОбластьОбложка.Параметры.КодОКПО = СведенияОбОрганизации.КодПоОКПО;
	ОбластьОбложка.Параметры.ГлБухгалтер = Руководители.ГлавныйБухгалтерПредставление;
	
	Обложка.Вывести(ОбластьОбложка);
	Обложка.ТолькоПросмотр = Истина;
	
	ПараметрыОтчета.СписокСформированныхЛистов.Добавить(Обложка, "Обложка");
	
КонецПроцедуры

Процедура СформироватьЖурналКассовыхДокументов(ПараметрыОтчета)
	
	Перем ДатаЛиста;
	
	ДокументРезультат = Новый ТабличныйДокумент;
	
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	ДокументРезультат.Очистить();
	ДокументРезультат.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЖурналРегистрацииКассовыхДокументов";
	
	ТипДата  = ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.Дата);
	ТипЧисло = ОбщегоНазначения.ОписаниеТипаЧисло(15,2);
	
	Макет = ПолучитьМакет("ЖурналРегистрацииКассовыхДокументов");
	
	//////////////////////////////////////////////////////////////////////////////////////////
	ОбластьШапка					= Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрокаОтчетПКО 			= Макет.ПолучитьОбласть("Строка|ПКО");
	ОбластьСтрокаОтчетРКО			= Макет.ПолучитьОбласть("Строка|РКО");
	ОбластьПустаяСтрокаОтчетПКО		= Макет.ПолучитьОбласть("ПустаяСтрока|ПКО");
	ОбластьПустаяСтрокаОтчетРКО		= Макет.ПолучитьОбласть("ПустаяСтрока|РКО");
	ОбластьСтрокаРубИтог			= Макет.ПолучитьОбласть("СтрокаРубИтог");
	ОбластьСтрокаВалИтог			= Макет.ПолучитьОбласть("СтрокаВалИтог");
	ОбластьРазделительГруппировка	= Макет.ПолучитьОбласть("РазделительГруппировка");
	////////////////////////////////////////////////////////////////////////////////////////////////
	
	//Выборка ПКО
	ЗапросПоДокументамПКО = Новый Запрос;
	ЗапросПоДокументамПКО.Текст=
	"ВЫБРАТЬ
	|	Док.Ссылка КАК Документ,
	|	НАЧАЛОПЕРИОДА(Док.Дата, ДЕНЬ) КАК День,
	|	Док.Номер,
	|	Док.Дата КАК Дата,
	|	ПРЕДСТАВЛЕНИЕ(Док.ВалютаДокумента) КАК ВалютаДокумента,
	|	СУММА(ВЫБОР
	|			КОГДА Док.ВалютаДокумента <> &ВалютаРегламентированногоУчета
	|				ТОГДА Док.СуммаДокумента
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ПриходВал,
	|	СУММА(ВЫБОР
	|			КОГДА Док.ВалютаДокумента <> &ВалютаРегламентированногоУчета
	|				ТОГДА Док.СуммаДокумента * КурсыВалют.Курс / КурсыВалют.Кратность
	|			ИНАЧЕ Док.СуммаДокумента
	|		КОНЕЦ) КАК Приход,
	|	КурсыВалют.Курс,
	|	КурсыВалют.Кратность
	|ИЗ
	|	Документ.ПриходныйКассовыйОрдер КАК Док
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют КАК КурсыВалют
	|		ПО Док.ВалютаДокумента = КурсыВалют.Валюта
	|			И (КурсыВалют.Период В
	|				(ВЫБРАТЬ
	|					МАКСИМУМ(КурсыВалют.Период) КАК Период
	|				ИЗ
	|					РегистрСведений.КурсыВалют КАК КурсыВалют
	|				ГДЕ
	|					КурсыВалют.Период <= Док.Дата
	|					И Док.ВалютаДокумента = КурсыВалют.Валюта))
	|ГДЕ
	|	Док.ПометкаУдаления = ЛОЖЬ
	|	И Док.Дата МЕЖДУ &НачИтоги И &КонецПериода
	|	И Док.Организация = &Организация
	|
	|СГРУППИРОВАТЬ ПО
	|	НАЧАЛОПЕРИОДА(Док.Дата, ДЕНЬ),
	|	Док.Ссылка,
	|	Док.Номер,
	|	Док.Дата,
	|	КурсыВалют.Курс,
	|	КурсыВалют.Кратность,
	|	ПРЕДСТАВЛЕНИЕ(Док.ВалютаДокумента)
	|
	|УПОРЯДОЧИТЬ ПО
	|	День,
	|	Документ
	|ИТОГИ ПО
	|	День,
	|	Документ
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	ЗапросПоДокументамПКО.УстановитьПараметр("НачИтоги",     НачалоДня(ПараметрыОтчета.НачалоПериода));
	ЗапросПоДокументамПКО.УстановитьПараметр("КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	ЗапросПоДокументамПКО.УстановитьПараметр("Организация",  ПараметрыОтчета.Организация);
	ЗапросПоДокументамПКО.УстановитьПараметр("ВалютаРегламентированногоУчета", ВалютаРегламентированногоУчета);
	РезультатЗапросаПоДокументамПКО = ЗапросПоДокументамПКО.Выполнить();
	ВыборкаПоДнямПКО				= РезультатЗапросаПоДокументамПКО.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "День");
	
	//Выборка РКО
	ЗапросПоДокументамРКО = Новый Запрос;
	ЗапросПоДокументамРКО.Текст=
	"ВЫБРАТЬ
	|	Док.Ссылка КАК Документ,
	|	НАЧАЛОПЕРИОДА(Док.Дата, ДЕНЬ) КАК День,
	|	Док.Номер,
	|	Док.Дата КАК Дата,
	|	ПРЕДСТАВЛЕНИЕ(Док.ВалютаДокумента) КАК ВалютаДокумента,
	|	СУММА(ВЫБОР
	|			КОГДА Док.ВалютаДокумента <> &ВалютаРегламентированногоУчета
	|				ТОГДА Док.СуммаДокумента
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК РасходВал,
	|	СУММА(ВЫБОР
	|			КОГДА Док.ВалютаДокумента <> &ВалютаРегламентированногоУчета
	|				ТОГДА Док.СуммаДокумента * КурсыВалют.Курс / КурсыВалют.Кратность
	|			ИНАЧЕ Док.СуммаДокумента
	|		КОНЕЦ) КАК Расход,
	|	КурсыВалют.Курс,
	|	КурсыВалют.Кратность
	|ИЗ
	|	Документ.РасходныйКассовыйОрдер КАК Док
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют КАК КурсыВалют
	|		ПО Док.ВалютаДокумента = КурсыВалют.Валюта
	|			И (КурсыВалют.Период В
	|				(ВЫБРАТЬ
	|					МАКСИМУМ(КурсыВалют.Период) КАК Период
	|				ИЗ
	|					РегистрСведений.КурсыВалют КАК КурсыВалют
	|				ГДЕ
	|					КурсыВалют.Период <= Док.Дата
	|					И Док.ВалютаДокумента = КурсыВалют.Валюта))
	|ГДЕ
	|	Док.ПометкаУдаления = ЛОЖЬ
	|	И Док.Дата МЕЖДУ &НачИтоги И &КонецПериода
	|	И Док.Организация = &Организация
	|
	|СГРУППИРОВАТЬ ПО
	|	НАЧАЛОПЕРИОДА(Док.Дата, ДЕНЬ),
	|	Док.Ссылка,
	|	Док.Номер,
	|	Док.Дата,
	|	КурсыВалют.Курс,
	|	КурсыВалют.Кратность,
	|	ПРЕДСТАВЛЕНИЕ(Док.ВалютаДокумента)
	|
	|УПОРЯДОЧИТЬ ПО
	|	День,
	|	Документ
	|ИТОГИ ПО
	|	День,
	|	Документ
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	ЗапросПоДокументамРКО.УстановитьПараметр("НачИтоги",НачалоДня(ПараметрыОтчета.НачалоПериода));
	ЗапросПоДокументамРКО.УстановитьПараметр("КонецПериода",КонецДня(ПараметрыОтчета.КонецПериода));
	ЗапросПоДокументамРКО.УстановитьПараметр("Организация",ПараметрыОтчета.Организация);
	ЗапросПоДокументамРКО.УстановитьПараметр("ВалютаРегламентированногоУчета",ВалютаРегламентированногоУчета);
	РезультатЗапросаПоДокументамРКО = ЗапросПоДокументамРКО.Выполнить();
	ВыборкаПоДнямРКО				= РезультатЗапросаПоДокументамРКО.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "День");
	
	КоличествоДней = Макс(ВыборкаПоДнямПКО.Количество(),ВыборкаПоДнямРКО.Количество());
	
	ДокументРезультат.ФиксацияСверху = 0;
	//Отчет формируем только в случае, если в указанном периоде есть документы
	Если КоличествоДней > 0 Тогда
		ДокументРезультат.Вывести(ОбластьШапка);
		ДокументРезультат.ПовторятьПриПечатиСтроки = ДокументРезультат.Область("Шапка");
		ДокументРезультат.ФиксацияСверху = 4;
		
		//Таблица валют
		ТаблицаВалют = Новый ТаблицаЗначений;
		ТаблицаВалют.Колонки.Добавить("ВалютаДокумента");
		ТаблицаВалют.Колонки.Добавить("Приход", ТипЧисло);
		ТаблицаВалют.Колонки.Добавить("ПриходВал", ТипЧисло);
		ТаблицаВалют.Колонки.Добавить("Расход", ТипЧисло);
		ТаблицаВалют.Колонки.Добавить("РасходВал", ТипЧисло);
		НаименованиеВалютыРегламентированногоУчета = ВалютаРегламентированногоУчета.Наименование;
		
		Если ПараметрыОтчета.ГруппироватьПоДатам Тогда
			//Формирование отчета с группировкой по датам
			ПериодВыборки = Новый ТаблицаЗначений;
			ПериодВыборки.Колонки.Добавить("День", ТипДата);
			Для СчетчикЦикла = 1 По  КоличествоДней Цикл
				Если ВыборкаПоДнямПКО.Следующий() Тогда
					НовыйПериодВыборки = ПериодВыборки.Добавить();
					ЗаполнитьЗначенияСвойств(НовыйПериодВыборки, ВыборкаПоДнямПКО);
				КонецЕсли;
				Если ВыборкаПоДнямРКО.Следующий() Тогда
					НовыйПериодВыборки = ПериодВыборки.Добавить();
					ЗаполнитьЗначенияСвойств(НовыйПериодВыборки, ВыборкаПоДнямРКО);
				КонецЕсли;
			КонецЦикла;
			ПериодВыборки.Свернуть("День");
			ПериодВыборки.Сортировать("День");
			
			ВыборкаПоДнямПКО = РезультатЗапросаПоДокументамПКО.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "День");
			ВыборкаПоДнямРКО = РезультатЗапросаПоДокументамРКО.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "День");
			
			Для Каждого СтрокаПериодВыборки Из ПериодВыборки Цикл
				ТаблицаВалют.Очистить();
				ОбластьРазделительГруппировка.Параметры.ДатаЗаписи = СтрокаПериодВыборки.День;
				ДокументРезультат.Вывести(ОбластьРазделительГруппировка);	
				
				ВыборкаПКОНеПустая = ВыборкаПоДнямПКО.НайтиСледующий(СтрокаПериодВыборки.День, "День");
				ВыборкаРКОНеПустая = ВыборкаПоДнямРКО.НайтиСледующий(СтрокаПериодВыборки.День, "День");
				ВыборкаПоДокументамПКО 	= ВыборкаПоДнямПКО.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Документ");
				ВыборкаПоДокументамРКО 	= ВыборкаПоДнямРКО.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Документ");
				
				КоличествоДокументов	=  Макс(?(ВыборкаПКОНеПустая, ВыборкаПоДокументамПКО.Количество(), 0),?(ВыборкаРКОНеПустая, ВыборкаПоДокументамРКО.Количество(), 0));
				Для СчетчикЦикла = 1 По КоличествоДокументов Цикл
					Если ВыборкаПоДокументамПКО.Следующий() И ВыборкаПКОНеПустая Тогда
						НомерДокПечатнойФормы = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ВыборкаПоДокументамПКО.Номер, Истина, Ложь);
						ОбластьСтрокаОтчетПКО.Параметры.НомерДокПечатнойФормы = НомерДокПечатнойФормы;
						
						ЗаполнитьЗначенияСвойств(ОбластьСтрокаОтчетПКО.Параметры,ВыборкаПоДокументамПКО);
						ТекстПримечания = ?(ВыборкаПоДокументамПКО.ВалютаДокумента = НаименованиеВалютыРегламентированногоУчета, "", "В валюте (" + ВыборкаПоДокументамПКО.ВалютаДокумента +")");
						ОбластьСтрокаОтчетПКО.Параметры.Примечание = ТекстПримечания;
						ДокументРезультат.Вывести(ОбластьСтрокаОтчетПКО);
						НоваяСтрокаТаблицаВалют = ТаблицаВалют.Добавить();
						ЗаполнитьЗначенияСвойств(НоваяСтрокаТаблицаВалют ,ВыборкаПоДокументамПКО);
					Иначе
						ДокументРезультат.Вывести(ОбластьПустаяСтрокаОтчетПКО);
					КонецЕсли;
					Если ВыборкаПоДокументамРКО.Следующий() И ВыборкаРКОНеПустая Тогда
						НомерДокПечатнойФормы = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ВыборкаПоДокументамРКО.Номер, Истина, Ложь);
						ОбластьСтрокаОтчетРКО.Параметры.НомерДокПечатнойФормы = НомерДокПечатнойФормы;
						
						ЗаполнитьЗначенияСвойств(ОбластьСтрокаОтчетРКО.Параметры,ВыборкаПоДокументамРКО);
						ТекстПримечания = ?(ВыборкаПоДокументамРКО.ВалютаДокумента = НаименованиеВалютыРегламентированногоУчета, "", "В валюте (" + ВыборкаПоДокументамРКО.ВалютаДокумента +")");
						ОбластьСтрокаОтчетРКО.Параметры.Примечание = ТекстПримечания;
						ДокументРезультат.Присоединить(ОбластьСтрокаОтчетРКО);
						НоваяСтрокаТаблицаВалют = ТаблицаВалют.Добавить();
						ЗаполнитьЗначенияСвойств(НоваяСтрокаТаблицаВалют ,ВыборкаПоДокументамРКО);
					Иначе
						ДокументРезультат.Присоединить(ОбластьПустаяСтрокаОтчетРКО);
					КонецЕсли;
				КонецЦикла;
				//Вывод итоговых сумм по датам
				Если ПараметрыОтчета.ГруппироватьПоДатам Тогда
					ТаблицаВалют.Свернуть("ВалютаДокумента", "Приход, ПриходВал, Расход, РасходВал");
					ОбластьСтрокаРубИтог.Параметры.Приход = ТаблицаВалют.Итог("Приход");
					ОбластьСтрокаРубИтог.Параметры.Расход = ТаблицаВалют.Итог("Расход");
					ДокументРезультат.Вывести(ОбластьСтрокаРубИтог);
					Для Каждого СтрокаТаблицаВалют Из ТаблицаВалют Цикл
						Если СтрокаТаблицаВалют.ВалютаДокумента <> НаименованиеВалютыРегламентированногоУчета Тогда
							ЗаполнитьЗначенияСвойств(ОбластьСтрокаВалИтог.Параметры ,СтрокаТаблицаВалют);
							ДокументРезультат.Вывести(ОбластьСтрокаВалИтог);
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			КонецЦикла;
			
		Иначе
			//Формирование отчета без группировки по датам
			ВыборкаПоДокументамПКО 	= РезультатЗапросаПоДокументамПКО.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Документ");
			ВыборкаПоДокументамРКО 	= РезультатЗапросаПоДокументамРКО.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Документ");
			КоличествоДокументов	=  Макс(ВыборкаПоДокументамПКО.Количество(),ВыборкаПоДокументамРКО.Количество());
			Для СчетчикЦикла = 1 По КоличествоДокументов Цикл
				Если ВыборкаПоДокументамПКО.Следующий() Тогда
					НомерДокПечатнойФормы = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ВыборкаПоДокументамПКО.Номер, Истина, Ложь);
					ОбластьСтрокаОтчетПКО.Параметры.НомерДокПечатнойФормы = НомерДокПечатнойФормы;
					
					ЗаполнитьЗначенияСвойств(ОбластьСтрокаОтчетПКО.Параметры,ВыборкаПоДокументамПКО);
					ТекстПримечания = ?(ВыборкаПоДокументамПКО.ВалютаДокумента = НаименованиеВалютыРегламентированногоУчета, "", "В валюте (" + ВыборкаПоДокументамПКО.ВалютаДокумента +")");
					ОбластьСтрокаОтчетПКО.Параметры.Примечание = ТекстПримечания;
					ДокументРезультат.Вывести(ОбластьСтрокаОтчетПКО);	
				Иначе
					ДокументРезультат.Вывести(ОбластьПустаяСтрокаОтчетПКО);	
				КонецЕсли;
				Если ВыборкаПоДокументамРКО.Следующий() Тогда
					НомерДокПечатнойФормы = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ВыборкаПоДокументамРКО.Номер, Истина, Ложь);
					ОбластьСтрокаОтчетРКО.Параметры.НомерДокПечатнойФормы = НомерДокПечатнойФормы;
					
					ЗаполнитьЗначенияСвойств(ОбластьСтрокаОтчетРКО.Параметры,ВыборкаПоДокументамРКО);
					ТекстПримечания = ?(ВыборкаПоДокументамРКО.ВалютаДокумента = НаименованиеВалютыРегламентированногоУчета, "", "В валюте (" + ВыборкаПоДокументамРКО.ВалютаДокумента +")");
					ОбластьСтрокаОтчетРКО.Параметры.Примечание = ТекстПримечания;
					ДокументРезультат.Присоединить(ОбластьСтрокаОтчетРКО);
				Иначе
					ДокументРезультат.Присоединить(ОбластьПустаяСтрокаОтчетРКО);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	ДокументРезультат.ТолькоПросмотр = Истина;
	
	ПараметрыОтчета.СписокСформированныхЛистов.Добавить(ДокументРезультат, "Страницы");
	
КонецПроцедуры

#КонецЕсли