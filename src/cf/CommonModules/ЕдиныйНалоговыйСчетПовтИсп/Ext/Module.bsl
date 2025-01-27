﻿#Область СлужебныйПрограммныйИнтерфейс

Функция ОбслуживаемыеСчетаУчета(Период) Экспорт
	
	СчетаПоОтбору = ОбслуживаемыеСчетаУчетаНалогов();
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(СчетаПоОтбору, ОбслуживаемыеСчетаУчетаСтраховыхВзносов(Период));
	
	Возврат СчетаПоОтбору;
	
КонецФункции

Функция ОбслуживаемыеСчетаУчетаНалогов() Экспорт
	
	МассивСчетов = Новый Массив;
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоНалогам);
	
	УсловияОтбораСубсчетов = БухгалтерскийУчет.НовыеУсловияОтбораСубсчетов();
	УсловияОтбораСубсчетов.ИспользоватьВПроводках = Истина;
	
	СчетаПоОтбору = БухгалтерскийУчет.СформироватьМассивСубсчетовПоОтбору(МассивСчетов, УсловияОтбораСубсчетов);
	
	Возврат СчетаПоОтбору;
	
КонецФункции

Функция ОбслуживаемыеСчетаУчетаСтраховыхВзносов(Период) Экспорт
	
	МассивСчетов = Новый Массив;
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоСоциальномуСтрахованию);
	
	УсловияОтбораСубсчетов = БухгалтерскийУчет.НовыеУсловияОтбораСубсчетов();
	УсловияОтбораСубсчетов.ИспользоватьВПроводках = Истина;
	
	СчетаПоОтбору = БухгалтерскийУчет.СформироватьМассивСубсчетовПоОтбору(МассивСчетов, УсловияОтбораСубсчетов);
	
	СчетаИсключения = Новый Массив;
	СчетаИсключения.Добавить(ПланыСчетов.Хозрасчетный.ФСС_НСиПЗ);        // 69.11
	СчетаИсключения.Добавить(ПланыСчетов.Хозрасчетный.ФСС_СтраховойГод); // 69.06.4
	СчетаИсключения.Добавить(ПланыСчетов.Хозрасчетный.ПФР_ДОБР_орг);     // 69.05.1
	СчетаИсключения.Добавить(ПланыСчетов.Хозрасчетный.ПФР_ДОБР_сотр);    // 69.05.2
	
	СчетаПоОтбору = ОбщегоНазначенияКлиентСервер.РазностьМассивов(СчетаПоОтбору, СчетаИсключения);
	
	Возврат СчетаПоОтбору;
	
КонецФункции

Функция ОбслуживаемыеСчетаУчетаСтраховыхВзносовИП() Экспорт
	
	МассивСчетов = Новый Массив;
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.Взносы_СтраховойГод); // 69.06
	
	УсловияОтбораСубсчетов = БухгалтерскийУчет.НовыеУсловияОтбораСубсчетов();
	УсловияОтбораСубсчетов.ИспользоватьВПроводках = Истина;
	
	СчетаПоОтбору = БухгалтерскийУчет.СформироватьМассивСубсчетовПоОтбору(МассивСчетов, УсловияОтбораСубсчетов);
	
	Возврат СчетаПоОтбору;
	
КонецФункции

Функция НалогиУплачиваемыеОтдельно() Экспорт
	
	МассивНалогов = Новый Массив;
	
	ВидыНалогов = ВидыНалоговУплачиваемыеОтдельно();
	Для Каждого ВидНалога Из ВидыНалогов Цикл
		Налог = Справочники.ВидыНалоговИПлатежейВБюджет.НалогПоВиду(ВидНалога, Ложь);
		Если ЗначениеЗаполнено(Налог) Тогда
			МассивНалогов.Добавить(Налог);
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивНалогов
	
КонецФункции

Функция ВидыНалоговУплачиваемыеОтдельно() Экспорт
	
	МассивВидовНалогов = Новый Массив;
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ЕдиныйНалоговыйПлатеж);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.СтраховыеВзносы_ФСС_НСиПЗ);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ФиксированныеВзносы_ФСС);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.СтраховыеВзносы_ПФР_Добровольные);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ФиксированныеВзносы_ПФР_Добровольные);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.НалогНаПрофессиональныйДоход);
	
	Возврат МассивВидовНалогов
	
КонецФункции

Функция ВидыНалоговУплачиваемыеБезУведомлений() Экспорт
	
	МассивВидовНалогов = Новый Массив;
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.АУСН);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ЕНВД);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ПСН_ВнутригородскойРайон);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ПСН_ГородскойОкруг);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ПСН_ГородскойОкругСВнутригородскимДелением);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ПСН_ГородФедеральногоЗначения);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ПСН_МуниципальныйОкруг);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ПСН_МуниципальныйРайон);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.НДС);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.НДС_ВвозимыеТовары);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.НалогНаПрибыль_РегиональныйБюджет);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.НалогНаПрибыль_ФедеральныйБюджет);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ТорговыйСбор);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ФиксированныеВзносы_СтраховыеВзносыЕдиныйТариф);
	
	Возврат МассивВидовНалогов
	
КонецФункции

Функция ВидыНалоговНеУплачиваемыхС2023Года() Экспорт
	
	МассивВидовНалогов = Новый Массив;
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.СтраховыеВзносы_ПФР_НакопительнаяЧасть);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.СтраховыеВзносы_ФСС);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ФиксированныеВзносы_ПФР_НакопительнаяЧасть);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.УСН_МинимальныйНалог);
	
	Возврат МассивВидовНалогов
	
КонецФункции

Функция ВидыНалоговНеУплачиваемыхС2024Года() Экспорт
	
	МассивВидовНалогов = Новый Массив;
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.СтраховыеВзносы_ПФР_СтраховаяЧасть);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.СтраховыеВзносы_ФФОМС);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ФиксированныеВзносы_ПФР_СтраховаяЧасть);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ФиксированныеВзносы_ФФОМС);
	
	Возврат МассивВидовНалогов
	
КонецФункции

Функция ВидыВозвращаемыхНалоговИсключения() Экспорт
	
	МассивВидовНалогов = Новый Массив;
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.СтраховыеВзносы_ФСС);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.СтраховыеВзносы_ФСС_НСиПЗ);
	
	Возврат МассивВидовНалогов
	
КонецФункции

Функция ВидыВозвращаемыхНалогов() Экспорт
	
	МассивВидовНалогов = Новый Массив;
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ПрочиеНалогиИСборы);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ЕдиныйНалоговыйПлатеж);
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивВидовНалогов, ВидыВозвращаемыхНалоговИсключения());
	
	Возврат МассивВидовНалогов
	
КонецФункции

Функция МассивДоступныхВидовНалогов() Экспорт
	
	МассивВидовНалогов = Новый Массив;
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ПустаяСсылка());
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ПрочиеНалогиИСборы);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.Госпошлина_ГосрегистрацияОрганизаций);
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивВидовНалогов, ВидыНалоговУплачиваемыеОтдельно());
	
	Возврат МассивВидовНалогов
	
КонецФункции

Функция МассивНедоступныхВидовНалогов(ПолныйСписок = Ложь) Экспорт
	
	МассивВидовНалогов = Новый Массив;
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ЕдиныйНалоговыйПлатеж);
	
	Если ПолныйСписок Тогда
		МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.Госпошлина_ГосрегистрацияОрганизаций);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивВидовНалогов, ВидыНалоговУплачиваемыеБезУведомлений());
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивВидовНалогов, ВидыНалоговНеУплачиваемыхС2023Года());
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивВидовНалогов, ВидыНалоговУплачиваемыеОтдельно());
		
		ТекущаяДата = ОбщегоНазначения.ТекущаяДатаПользователя();
		ПериодИзмененияСтраховыхВзносов = ПлатежиВБюджетКлиентСерверПереопределяемый.ПериодИзмененияСтраховыхВзносов();
		Если НачалоГода(ТекущаяДата) > НачалоГода(ПериодИзмененияСтраховыхВзносов) Тогда
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивВидовНалогов, ВидыНалоговНеУплачиваемыхС2024Года());
		КонецЕсли;
	КонецЕсли;
	
	Возврат МассивВидовНалогов
	
КонецФункции

Функция ВидыАгентскогоНДФЛ() Экспорт
	
	МассивВидовНалогов = Новый Массив;
	// НДФЛ
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.НДФЛ);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.НДФЛ_ДоходыСвышеПредельнойВеличины);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.НДФЛ_Дивиденды);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.НДФЛ_Дивиденды_ДоходыСвышеПредельнойВеличины);
	
	Возврат МассивВидовНалогов;
	
КонецФункции

Функция ВидыПредпринимательскогоНДФЛ() Экспорт
	
	МассивВидовНалогов = Новый Массив;
	// НДФЛ
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.НДФЛ_ИП);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.НДФЛ_ИП_НалоговаяБазаСвышеПредельнойВеличины);

	Возврат МассивВидовНалогов;
	
КонецФункции

Функция ВидыИмущественныхНалогов() Экспорт
	
	МассивВидовНалогов = Новый Массив;
	
	// Имущество
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.НалогНаИмущество);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.НалогНаИмуществоЕСГС);
	
	// Транспорт
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ТранспортныйНалог);
	
	// Земля
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ЗемельныйНалог_ВнутригородскойОкруг);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ЗемельныйНалог_ГородскоеПоселение);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ЗемельныйНалог_ГородскойОкруг);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ЗемельныйНалог_ГородскойОкругСВнутригородскимДелением);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ЗемельныйНалог_ГородФедеральногоЗначения);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ЗемельныйНалог_МежселеннаяТерритория);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ЗемельныйНалог_МуниципальныйОкруг);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ЗемельныйНалог_СельскоеПоселение);
	
	Возврат МассивВидовНалогов;
	
КонецФункции

Функция ВидыСтраховыхВзносов() Экспорт
	
	МассивВидовНалогов = Новый Массив;
	
	// ПФР - кроме добровольных
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.СтраховыеВзносы_ПФР_НакопительнаяЧасть);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.СтраховыеВзносы_ПФР_СтраховаяЧасть);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ФиксированныеВзносы_ПФР_НакопительнаяЧасть);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ФиксированныеВзносы_ПФР_СтраховаяЧасть);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ДополнительныеВзносы_ПФР_ВредныеУсловия);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ДополнительныеВзносы_ПФР_ЛетныеЭкипажи);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ДополнительныеВзносы_ПФР_ТяжелыеУсловия);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ДополнительныеВзносы_ПФР_Шахтеры);
	
	// ФСС - кроме НС и ПЗ и фиксированных взносов
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.СтраховыеВзносы_ФСС);
	
	// ФФОМС
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.СтраховыеВзносы_ФФОМС);
	
	// Единый тариф
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.СтраховыеВзносыЕдиныйТариф);
	
	// Иностранцы
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.СтраховыеВзносы_ОПС_ИностранныеРаботники);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.СтраховыеВзносы_ОМС_ИностранныеРаботники);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.СтраховыеВзносы_ОСС_ИностранныеРаботники);
	
	Возврат МассивВидовНалогов;
	
КонецФункции

Функция НалогиУплачиваемыеПоквартально() Экспорт
	
	МассивВидовНалогов = Новый Массив;
	
	// УСН
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.УСН_Доходы);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.УСН_ДоходыМинусРасходы);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.УСН_МинимальныйНалог);
	
	// ЕСХН
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.ЕСХН);
	
	// Прибыль
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.НалогНаПрибыль_РегиональныйБюджет);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.НалогНаПрибыль_ФедеральныйБюджет);
	
	// Имущественные налоги
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивВидовНалогов, ВидыИмущественныхНалогов());
	
	// НДФЛ ИП
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивВидовНалогов, ВидыПредпринимательскогоНДФЛ());
	
	Возврат МассивВидовНалогов;
	
КонецФункции

Функция НалогиУплачиваемыеЕжемесячно() Экспорт
	
	МассивВидовНалогов = Новый Массив;
	
	// Прибыль агента
	МассивВидовНалогов.Добавить(перечисления.ВидыНалогов.НалогНаПрибыль_НалоговыйАгент);
	
	// Страховые взносы
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.СтраховыеВзносы_ПФР_НакопительнаяЧасть);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.СтраховыеВзносы_ПФР_СтраховаяЧасть);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.СтраховыеВзносы_ФФОМС);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.СтраховыеВзносыЕдиныйТариф);
	
	// Иностранцы
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.СтраховыеВзносы_ОПС_ИностранныеРаботники);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.СтраховыеВзносы_ОМС_ИностранныеРаботники);
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.СтраховыеВзносы_ОСС_ИностранныеРаботники);
	
	// НДФЛ агента
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивВидовНалогов, ВидыАгентскогоНДФЛ());
	
	Возврат МассивВидовНалогов;
	
КонецФункции

Функция ВсеВидыНалоговНДФЛ() Экспорт
	
	МассивВидовНалогов = Новый Массив;
	
	// Дополним НДФЛ агента
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивВидовНалогов, ВидыНалоговНДФЛНалоговогоАгента());
	
	// Дополним НДФЛ предпринимателя
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивВидовНалогов, ВидыНалоговНДФЛПредпринимателя());
	
	// Дополним НДФЛ самостоятельно исчисленный
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивВидовНалогов, ВидыНалоговНДФЛСамостоятельно());
	
	// Вернем весь НДФЛ
	Возврат Новый ФиксированныйМассив(МассивВидовНалогов);
	
КонецФункции

Функция ВидыНалоговНДФЛНалоговогоАгента() Экспорт
	
	МассивВидовНалогов = Новый Массив;
	
	// НДФЛ налогового агента
	ВидыАгентскогоНДФЛ = ВидыАгентскогоНДФЛ();
	Для Каждого ВидНалога Из ВидыАгентскогоНДФЛ Цикл
		МассивВидовНалогов.Добавить(Справочники.ВидыНалоговИПлатежейВБюджет.НалогПоВиду(ВидНалога, Ложь));
	КонецЦикла;
	
	// Дополним НДФЛ, формально не обслуживаемым
	МассивСчетов = Новый Массив;
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.НДФЛ);
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.НДФЛ_ДоходыСвышеПредельнойВеличины);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СчетаУчета",  МассивСчетов);
	Запрос.УстановитьПараметр("ВидыНалогов", МассивВидовНалогов);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВидыНалоговИПлатежейВБюджет.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ВидыНалоговИПлатежейВБюджет КАК ВидыНалоговИПлатежейВБюджет
	|ГДЕ
	|	ВидыНалоговИПлатежейВБюджет.СчетУчета В(&СчетаУчета)
	|	И НЕ ВидыНалоговИПлатежейВБюджет.Ссылка В (&ВидыНалогов)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МассивВидовНалогов.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(МассивВидовНалогов);
	
КонецФункции

Функция ВидыНалоговНДФЛПредпринимателя() Экспорт
	
	МассивВидовНалогов = Новый Массив;
	
	// НДФЛ предпринимателя
	ВидыПредпринимательскогоНДФЛ = ВидыПредпринимательскогоНДФЛ();
	Для Каждого ВидНалога Из ВидыПредпринимательскогоНДФЛ Цикл
		МассивВидовНалогов.Добавить(Справочники.ВидыНалоговИПлатежейВБюджет.НалогПоВиду(ВидНалога, Ложь));
	КонецЦикла;
	
	// Дополним НДФЛ, формально не обслуживаемым
	МассивСчетов = Новый Массив;
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.НДФЛ_ИП);
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.НДФЛ_ИП_НалоговаяБазаСвышеПредельнойВеличины);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СчетаУчета",  МассивСчетов);
	Запрос.УстановитьПараметр("ВидыНалогов", МассивВидовНалогов);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВидыНалоговИПлатежейВБюджет.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ВидыНалоговИПлатежейВБюджет КАК ВидыНалоговИПлатежейВБюджет
	|ГДЕ
	|	ВидыНалоговИПлатежейВБюджет.СчетУчета В(&СчетаУчета)
	|	И НЕ ВидыНалоговИПлатежейВБюджет.Ссылка В (&ВидыНалогов)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МассивВидовНалогов.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(МассивВидовНалогов);
	
КонецФункции

Функция ВидыНалоговНДФЛСамостоятельно() Экспорт
	
	МассивВидовНалогов = Новый Массив;
	
	МассивВидовНалогов.Добавить(Справочники.ВидыНалоговИПлатежейВБюджет.НалогПоВиду(Перечисления.ВидыНалогов.НДФЛ_ФизЛицо, Ложь));
	
	Возврат Новый ФиксированныйМассив(МассивВидовНалогов);
	
КонецФункции

Функция ВидыНалоговНаИмущество() Экспорт
	
	МассивВидовНалогов = Новый Массив;
	
	ВидыИмущественныхНалогов = ВидыИмущественныхНалогов();
	Для Каждого ВидНалога Из ВидыИмущественныхНалогов Цикл
		МассивВидовНалогов.Добавить(Справочники.ВидыНалоговИПлатежейВБюджет.НалогПоВиду(ВидНалога, Ложь));
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(МассивВидовНалогов);
	
КонецФункции

Функция ВидыНалоговСтраховыеВзносы() Экспорт
	
	МассивВидовНалогов = Новый Массив;
	
	ВидыСтраховыхВзносов = ВидыСтраховыхВзносов();
	Для Каждого ВидНалога Из ВидыСтраховыхВзносов Цикл
		ВидНалогаПлатежа = Справочники.ВидыНалоговИПлатежейВБюджет.НалогПоВиду(ВидНалога, Ложь);
		
		// Если такого предопределенного элемента справочника не было ранее создано,
		// то функция вернет ссылку на обязательный вид "Прочие налоги и сборы".
		// В этом случае пропускаем такое значение
		Если ВидНалогаПлатежа = Справочники.ВидыНалоговИПлатежейВБюджет.ПрочиеНалогиИСборы Тогда
			Продолжить;
		КонецЕсли;
		
		МассивВидовНалогов.Добавить(ВидНалогаПлатежа);
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(МассивВидовНалогов);
	
КонецФункции

#КонецОбласти
