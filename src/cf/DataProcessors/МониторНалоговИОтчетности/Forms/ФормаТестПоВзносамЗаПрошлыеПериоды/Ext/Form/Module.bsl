﻿
&НаКлиенте
Перем ЗаданныеВопросы;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	АдресСведенийОбОрганизации = Параметры.АдресСведенийОбОрганизации;
	СведенияОбОрганизации = ПолучитьИзВременногоХранилища(АдресСведенийОбОрганизации);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СведенияОбОрганизации);
	
	ВводЗадолженности = Параметры.ВводЗадолженности;
	Правило           = Параметры.Правило;
	
	КодЗадачи = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Правило, "Владелец.Код");
	
	ЭтоИПНулевка = Не ОбщегоНазначенияБПВызовСервераПовтИсп.ЭтоЮрЛицо(Организация)
		И Не ТарификацияБПВызовСервераПовтИсп.РазрешенУчетРегулярнойДеятельности();
	
	Период = ПомощникиПоУплатеНалоговИВзносов.ГраницаОтчетностиПрошлыхПериодов(Организация);
	
	УплачиваетсяВзносПФРСДоходов = УплачиваетсяВзносПФРСДоходов(Период);
	
	ПерешлиНаЕдиныйТариф = Период >= УчетЗарплаты.ДатаПереходаНаЕдиныйТарифСтраховыхВзносов();
	
	УстановитьТекстыЭлементовФормы();
	
	ЗаполнитьЗадолженность();
	
	НомерВопроса = 0;
	
	Если ВводЗадолженности Тогда
		СледующийВопрос = "ГруппаВводЗадолженности";
	ИначеЕсли Подключена1СОтчетность И ЭтоИПНулевка Тогда
		
		Если РегистрацияВПрошломГоду Тогда
			СледующийВопрос = "ГруппаВопрос8";
		Иначе
			СледующийВопрос = "ГруппаВопрос7";
		КонецЕсли;
		
	Иначе
	
		Если РегистрацияВПрошломГоду Тогда
			
			СледующийВопрос = "ГруппаВопрос6";
			ОплаченныеГоды.Добавить(ГодНачалаДеятельности, Формат(ГодНачалаДеятельности, "ЧГ=0") + " " + НСтр("ru = 'год'"));
			
		ИначеЕсли РегистрацияДо3Лет Тогда
			
			СледующийВопрос = "ГруппаВопрос1";
			Для Год = ГодНачалаДеятельности По ГодТекущий - 1 Цикл
				ОплаченныеГоды.Добавить(Год, Формат(Год, "ЧГ=0") + " " + НСтр("ru = 'год'"));
			КонецЦикла;
			
		ИначеЕсли РегистрацияБолее3Лет Тогда
			
			СледующийВопрос = "ГруппаВопрос1";
			Для Год = ГодТекущий - 3 По ГодТекущий - 1 Цикл
				ОплаченныеГоды.Добавить(Год, Формат(Год, "ЧГ=0") + " " + НСтр("ru = 'год'"));
			КонецЦикла;
			
		КонецЕсли;
	
	КонецЕсли;
	
	// Проверка заполненности реквизитов организации, необходимых для операции по ЕНС.
	ТекстДействия = НСтр("ru = 'сформировать задолженность за прошлые годы'");
	СообщениеТребуютсяРеквизиты = 
		ПроверкаРеквизитовОрганизации.СтрокаСообщенияНеЗаполненыРеквизитыДляОтчетности(Организация, ТекстДействия);
	РеквизитыОрганизацииЗаполнены = ПроверитьРеквизитыОрганизации(Организация).РеквизитыЗаполнены;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаданныеВопросы = Новый Массив;
	Далее();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Отправлен запрос в ФНС через 1С-Отчетность.
	Если ИмяСобытия = "Успешная отправка"
		И ТипЗнч(Параметр) = Тип("Структура")
		И Параметр.Свойство("РезультатОтправки")
		И ТипЗнч(Параметр.РезультатОтправки) = Тип("ДокументСсылка.ЗапросНаИнформационноеОбслуживаниеНалогоплательщика") Тогда
		
		ЗапрошенаСправкаСохранитьСостояниеПомощника(Организация, Параметр.РезультатОтправки);
		Оповестить("ПомощникОплатыВзносовИП_ИзменениеСостояния");
		
		Результат = Новый Структура;
		Результат.Вставить("АдресСведенийОбОрганизации", АдресСведенийОбОрганизации);
		Результат.Вставить("РезультатТестирования",      Неопределено); // Результат тестирования обработан в форме тестов.
		Результат.Вставить("ОплаченныеГоды",             ОплаченныеГоды);
		Результат.Вставить("ДолгПС",  ДолгПС);
		Результат.Вставить("ДолгПС_СвышеПредела", ДолгПС_СвышеПредела);
		Результат.Вставить("ПеняПС",  ПеняПС);
		Результат.Вставить("ШтрафПС", ШтрафПС);
		Результат.Вставить("ДолгМС",  ДолгМС);
		Результат.Вставить("ПеняМС",  ПеняМС);
		Результат.Вставить("ШтрафМС", ШтрафМС);
		Результат.Вставить("ДолгЕдиныйТариф", ДолгЕдиныйТариф);
		Результат.Вставить("ПеняЕдиныйТариф", ПеняЕдиныйТариф);
		Результат.Вставить("ШтрафЕдиныйТариф", ШтрафЕдиныйТариф);
		
		Если ПроверитьЗаполнение() Тогда
			Закрыть(Результат);
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "Запись_Организации"
		И Организация = Источник Тогда
		
		РеквизитыОрганизацииЗаполнены = ПроверитьРеквизитыОрганизации(Организация).РеквизитыЗаполнены;
		УправлениеФормой(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	РезультатПроверкиРеквизитовОрганизации = ПроверитьРеквизитыОрганизации(Организация);
	Если Не РезультатПроверкиРеквизитовОрганизации.РеквизитыЗаполнены Тогда
		ТекстОписанияОбъектаПроверки = НСтр("ru = 'формирования задолженности за прошлые годы'");
		ПроверкаРеквизитовОрганизации.СообщитьОбОшибкеЗаполненияРеквизитовДляОтчетности(
		Организация,
		РезультатПроверкиРеквизитовОрганизации.НезаполненныеРеквизиты,
		"СообщениеТребуютсяРеквизиты",
		Отказ,
		ТекстОписанияОбъектаПроверки)
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура Переключатель1ПриИзменении(Элемент)
	
	ПодготовитьВопрос1();
	УстановитьЗаголовок();
	
КонецПроцедуры

&НаКлиенте
Процедура Переключатель2ПриИзменении(Элемент)
	
	УстановитьЗаголовок();
	
КонецПроцедуры

&НаКлиенте
Процедура Переключатель3ПриИзменении(Элемент)
	
	ПодготовитьВопрос3();
	
	УстановитьЗаголовок();
	
КонецПроцедуры

&НаКлиенте
Процедура Флажок4_1ПриИзменении(Элемент)
	
	УстановитьЗаголовок();
	
КонецПроцедуры

&НаКлиенте
Процедура Флажок4_2ПриИзменении(Элемент)
	
	УстановитьЗаголовок();
	
КонецПроцедуры

&НаКлиенте
Процедура Флажок4_3ПриИзменении(Элемент)
	
	УстановитьЗаголовок();
	
КонецПроцедуры

&НаКлиенте
Процедура Переключатель8ПриИзменении(Элемент)
	
	СледующийВопрос = Переключатель8;
	
КонецПроцедуры

&НаКлиенте
Процедура СообщениеТребуютсяРеквизитыОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ",                 Организация);
	ПараметрыФормы.Вставить("Назначение",           "ДляОтчетности");
	ПараметрыФормы.Вставить("ПроверяемыеРеквизиты", ПроверяемыеРеквизитыОрганизации(Организация));
	
	ОткрытьФорму("Справочник.Организации.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КнопкаДалее(Команда)
	
	Далее();
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаНазад(Команда)
	
	Назад();
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаГотово(Команда)
	
	Далее();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Далее()
	
	НомерВопроса = НомерВопроса + 1;
	ПерейтиКВопросу();
	
КонецПроцедуры

&НаКлиенте
Процедура Назад()
	
	НомерВопроса = НомерВопроса - 1;
	ЗаданныеВопросы.Удалить(ЗаданныеВопросы.ВГраница());
	СледующийВопрос = ЗаданныеВопросы[ЗаданныеВопросы.ВГраница()];
	ПерейтиКВопросу(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКВопросу(ШагНазад = Ложь)
	
	ИмяТекущейСтраницы = Элементы.ГруппаТест.ТекущаяСтраница.Имя;
	
	Если ИмяТекущейСтраницы = "ГруппаВопрос4" Тогда
		
		// Запоминаем годы, когда взносы были оплачены.
		Для Н = 1 по 3 Цикл
			
			ИмяЭлемента = "Флажок4_" + Н;
			Элемент = Элементы[ИмяЭлемента];
			Если Не Элемент.Видимость Тогда
				Прервать;
			КонецЕсли;
			ОплаченныеГоды[Н - 1].Пометка = ЭтотОбъект[ИмяЭлемента];
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СледующийВопрос) Тогда
		
		Если ИмяТекущейСтраницы = "ГруппаВопрос1" Тогда
			СледующийВопрос = Переключатель1;
		ИначеЕсли ИмяТекущейСтраницы = "ГруппаВопрос2" Тогда
			
			СледующийВопрос = Переключатель2;
			
			Если Не ЭтоИПНулевка И СледующийВопрос = "ГруппаВопрос3" Тогда
				// Сценарий запроса справки о расчетах с ФНС поддерживается только в сервисе Нулевка.
				// В обычном режиме работы сразу переходим к вопросу о неоплаченных годах.
				СледующийВопрос = "ГруппаВопрос4";
			КонецЕсли;
			
		ИначеЕсли ИмяТекущейСтраницы = "ГруппаВопрос4" Тогда
			
			КоличествоПометок = 0;
			Для Каждого ЭлементСписка Из ОплаченныеГоды Цикл
				КоличествоПометок = КоличествоПометок + ?(ЭлементСписка.Пометка, 1, 0);
			КонецЦикла;
			
			Если КоличествоПометок = ОплаченныеГоды.Количество() Тогда // Все годы оплачены.
				СледующийВопрос = РезультатПрошлыеГодыОплачены();
			Иначе
				СледующийВопрос = РезультатЕстьДолги();
			КонецЕсли;
			
		ИначеЕсли ИмяТекущейСтраницы = "ГруппаВопрос3" Тогда
			СледующийВопрос = Переключатель3;
		ИначеЕсли ИмяТекущейСтраницы = "ГруппаВопрос6" Тогда
			СледующийВопрос = Переключатель6;
		ИначеЕсли ИмяТекущейСтраницы = "ГруппаВопрос7" Тогда
			СледующийВопрос = Переключатель7;
		ИначеЕсли ИмяТекущейСтраницы = "ГруппаВопрос8" Тогда
			СледующийВопрос = Переключатель8;
		ИначеЕсли ИмяТекущейСтраницы = "ГруппаВводЗадолженности" Тогда
			СледующийВопрос = РезультатВведенаЗадолженность();
		КонецЕсли;
		
	КонецЕсли;
	
	Если СледующийВопрос = "ГруппаВопрос1" Тогда
		ПодготовитьВопрос1();
	ИначеЕсли СледующийВопрос = "ГруппаВопрос2" Тогда
		ПодготовитьВопрос2();
	ИначеЕсли СледующийВопрос = "ГруппаВопрос3" Тогда
		ПодготовитьВопрос3();
	ИначеЕсли СледующийВопрос = "ГруппаВопрос4" Тогда
		ПодготовитьВопрос4();
	ИначеЕсли СледующийВопрос = "ГруппаВопрос6" Тогда
		ПодготовитьВопрос6();
	ИначеЕсли СледующийВопрос = "ГруппаВопрос7" Тогда
		ПодготовитьВопрос7();
	ИначеЕсли СледующийВопрос = "ГруппаВопрос8" Тогда
		ПодготовитьВопрос8();
	ИначеЕсли СледующийВопрос = "ГруппаВводЗадолженности" Тогда
		ПодготовитьСтраницуВводаЗадолженности();
	КонецЕсли;
	
	Если СледующийВопрос = РезультатПрошлыеГодыОплачены()
		ИЛИ СледующийВопрос = РезультатЕстьДолги()
		ИЛИ СледующийВопрос = РезультатПодготовитьЗаявление()
		ИЛИ СледующийВопрос = РезультатПолучитьСправку()
		ИЛИ СледующийВопрос = РезультатВведенаЗадолженность() Тогда
		
		Если СледующийВопрос = РезультатВведенаЗадолженность()
			И (ДолгПС + ДолгМС + ДолгЕдиныйТариф
			+ ПеняПС + ПеняМС + ПеняЕдиныйТариф
			+ ШтрафПС + ШтрафМС + ШтрафЕдиныйТариф
			+ ДолгПС_СвышеПредела) = 0 Тогда
			
			// Пользователь указал, что задолженность по взносам = 0.
			СледующийВопрос = РезультатПрошлыеГодыОплачены(); 
		КонецЕсли;
		
		ПроверитьРезультатИЗавершитьТест(СледующийВопрос);
		
	Иначе
		
		Элементы.ГруппаТест.ТекущаяСтраница = Элементы[СледующийВопрос];
		УстановитьЗаголовок();
		Если Не ШагНазад Тогда
			ЗаданныеВопросы.Добавить(СледующийВопрос);
		КонецЕсли;
		СледующийВопрос = "";
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекстыЭлементовФормы()
	
	// Вопрос 1.
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Элементы.НадписьДополнение1.Заголовок
			= НСтр("ru = 'Если есть сомнения, сервис поможет определить вашу задолженность по страховым взносам за себя.'");
	Иначе
		Элементы.НадписьДополнение1.Заголовок
			= НСтр("ru = 'Если есть сомнения, программа поможет определить вашу задолженность по страховым взносам за себя.'");
	КонецЕсли;
	
	// Ввод задолженности.
	
	ПредставлениеДатыНачалаУчета = Формат(КонецГода(Период) + 1, "ДЛФ=D");
	ПредставлениеПрошлогоГода    = Формат(Год(Период), "ЧГ=0");
	
	ПредставлениеСрокаУплатыВзносовСДоходов = Формат(
		УчетСтраховыхВзносовИП.СрокУплатыВзносовСвышеПредела(Период),
		"ДЛФ=DD");
	ПредставлениеПределаДоходов = Формат(
		УчетСтраховыхВзносовИП.ПредельныйДоходНеОблагаемыйВзносамиВПФР(),
		"ЧДЦ=0");
	
	Элементы.НадписьВводЗадолженности.Заголовок = СтрШаблон(
		НСтр("ru = 'Укажите задолженность по взносам на %1'"),
		ПредставлениеДатыНачалаУчета);
	
	Элементы.ГруппаВводЗадолженностиВзносыСДоходов.Заголовок = СтрШаблон(
		НСтр("ru = 'К оплате до %1'"),
		ПредставлениеСрокаУплатыВзносовСДоходов);
		
	ДолгПС_СвышеПределаЗаголовок = ?(ПерешлиНаЕдиныйТариф,
		НСтр("ru='С доходов за %1 год'"),
		НСтр("ru='ПФР с доходов за %1 год'"));
	Элементы.ДолгПС_СвышеПредела.Заголовок = СтрШаблон(ДолгПС_СвышеПределаЗаголовок, ПредставлениеПрошлогоГода);
	Элементы.ДолгПС_СвышеПределаРасширеннаяПодсказка.Заголовок = СтрШаблон(
		НСтр("ru = 'Взнос в размере 1%% с дохода выше %1 рублей.
					|Укажите, если сумма взноса известна по данным учета за %2 год.
					|В документах из ФНС этой суммы еще нет, поскольку срок оплаты не истек.'"),
		ПредставлениеПределаДоходов,
		ПредставлениеПрошлогоГода);
	
	ВводЗадолженностиПостояннаяЧастьРасширеннаяПодсказка = ?(ПерешлиНаЕдиныйТариф,
		НСтр("ru = 'Взносы, срок уплаты по которым истек ранее %1, а также штрафы и пени.
					|Если есть требование или справка о расчетах из ФНС, укажите суммы оттуда. Если вводите долг по данным учета прошлых лет, сумму взноса указывайте без учета взноса с доходов за %2 год.'"),
		НСтр("ru = 'Взносы, срок уплаты по которым истек ранее %1, а также штрафы и пени.
					|Если есть требование или справка о расчетах из ФНС, укажите суммы оттуда. Если вводите долг по данным учета прошлых лет, сумму взноса в ПФР указывайте без учета взноса с доходов за %2 год.'"));
	
	Элементы.ЗаголовокВводЗадолженностиПостояннаяЧастьРасширеннаяПодсказка.Заголовок = СтрШаблон(
			ВводЗадолженностиПостояннаяЧастьРасширеннаяПодсказка,
			ПредставлениеДатыНачалаУчета,
			ПредставлениеПрошлогоГода);
	
КонецПроцедуры

// Первый вопрос, если с момента регистрации ИП прошло более года.
&НаКлиенте
Процедура ПодготовитьВопрос1()
	
	Шаблон = НСтр("ru = 'Оплатили ли вы страховые взносы за %1-%2 годы?'");
	Элементы.НадписьВопрос1.Заголовок = СтрШаблон(Шаблон,
		?(РегистрацияБолее3Лет, Формат(ГодТекущий - 3, "ЧГ=0"), Формат(ГодНачалаДеятельности, "ЧГ=0")),
		Формат(ГодТекущий - 1, "ЧГ=0"));
	Если Не ЗначениеЗаполнено(Переключатель1) Тогда
		Переключатель1 = Элементы.Переключатель1.СписокВыбора[0].Значение;
	КонецЕсли;
	Элементы.КнопкаНазад.Видимость  = Ложь;
	Если Переключатель1 = РезультатПрошлыеГодыОплачены() Тогда
		Элементы.КнопкаДалее.Видимость  = Ложь;
		Элементы.КнопкаГотово.Видимость = Истина;
		Элементы.КнопкаГотово.КнопкаПоУмолчанию = Истина;
	Иначе
		Элементы.КнопкаДалее.Видимость  = Истина;
		Элементы.КнопкаДалее.КнопкаПоУмолчанию = Истина;
		Элементы.КнопкаГотово.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодготовитьВопрос2()
	
	Если Не ЗначениеЗаполнено(Переключатель2) Тогда
		Переключатель2 = Элементы.Переключатель2_1.СписокВыбора[0].Значение;
	КонецЕсли;
	
	Элементы.КнопкаНазад.Видимость = Истина;
	Элементы.КнопкаДалее.Видимость = Истина;
	Элементы.КнопкаДалее.КнопкаПоУмолчанию = Истина;
	Элементы.КнопкаГотово.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодготовитьВопрос3()
	
	Если Не ЗначениеЗаполнено(Переключатель3) Тогда
		Переключатель3 = Элементы.Переключатель3_1.СписокВыбора[0].Значение;
	КонецЕсли;
	
	ЗавершениеТеста = (Переключатель3 = РезультатПодготовитьЗаявление());
	
	Элементы.КнопкаНазад.Видимость = Истина;
	Элементы.КнопкаДалее.Видимость = Не ЗавершениеТеста;
	Элементы.КнопкаДалее.КнопкаПоУмолчанию = Не ЗавершениеТеста;
	Элементы.КнопкаГотово.Видимость = ЗавершениеТеста;
	Элементы.КнопкаГотово.КнопкаПоУмолчанию = ЗавершениеТеста;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодготовитьВопрос4()
	
	Элементы.Флажок4_1.Видимость = Ложь;
	Элементы.Флажок4_2.Видимость = Ложь;
	Элементы.Флажок4_3.Видимость = Ложь;
	
	Сч = 0;
	Для Каждого ЭлементСписка Из ОплаченныеГоды Цикл
		
		Сч = Сч + 1;
		ИмяЭлемента = "Флажок4_" + Сч;
		Элемент = Элементы[ИмяЭлемента];
		Элемент.Видимость       = Истина;
		Элемент.Заголовок       = ЭлементСписка.Представление;
		ЭтотОбъект[ИмяЭлемента] = ЭлементСписка.Пометка;
		
	КонецЦикла;
	
	Элементы.КнопкаНазад.Видимость = Истина;
	Элементы.КнопкаДалее.Видимость = Ложь;
	Элементы.КнопкаГотово.Видимость = Истина;
	Элементы.КнопкаГотово.КнопкаПоУмолчанию = Истина;
	
КонецПроцедуры

// Первый вопрос, если ИП зарегистрировался в прошлом году.
&НаКлиенте
Процедура ПодготовитьВопрос6()
	
	Шаблон = НСтр("ru = 'Оплатили ли вы страховые взносы за %1 год?'");
	Элементы.НадписьВопрос6.Заголовок = СтрШаблон(Шаблон, Формат(ГодНачалаДеятельности, "ЧГ=0"));
	Если Не ЗначениеЗаполнено(Переключатель6) Тогда
		Переключатель6 = Элементы.Переключатель6.СписокВыбора[0].Значение;
	КонецЕсли;
	Элементы.КнопкаНазад.Видимость  = Ложь;
	Элементы.КнопкаДалее.Видимость  = Истина;
	Элементы.КнопкаДалее.КнопкаПоУмолчанию = Истина;
	Элементы.КнопкаГотово.Видимость = Ложь;
	
КонецПроцедуры

// Первый вопрос, если с момента регистрации ИП прошло более года  и есть 1С-Отчетность.
&НаКлиенте
Процедура ПодготовитьВопрос7()
	
	Шаблон = НСтр("ru = 'Оплатили ли вы страховые взносы за %1-%2 годы?'");
	Элементы.НадписьВопрос7.Заголовок = СтрШаблон(Шаблон,
		?(РегистрацияБолее3Лет, Формат(ГодТекущий - 3, "ЧГ=0"), Формат(ГодНачалаДеятельности, "ЧГ=0")),
		Формат(ГодТекущий - 1, "ЧГ=0"));
	Если Не ЗначениеЗаполнено(Переключатель7) Тогда
		Переключатель7 = Элементы.Переключатель7.СписокВыбора[0].Значение;
	КонецЕсли;
	Элементы.КнопкаНазад.Видимость  = Ложь;
	Элементы.КнопкаДалее.Видимость  = Истина;
	Элементы.КнопкаДалее.КнопкаПоУмолчанию = Истина;
	Элементы.КнопкаГотово.Видимость = Ложь;
	
КонецПроцедуры

// Первый вопрос, если ИП зарегистрировался в прошлом году и есть 1С-Отчетность.
&НаКлиенте
Процедура ПодготовитьВопрос8()
	
	Шаблон = НСтр("ru = 'Оплатили ли вы страховые взносы за %1 год?'");
	Элементы.НадписьВопрос8.Заголовок = СтрШаблон(Шаблон, Формат(ГодНачалаДеятельности, "ЧГ=0"));
	Если Не ЗначениеЗаполнено(Переключатель8) Тогда
		Переключатель8 = Элементы.Переключатель8.СписокВыбора[0].Значение;
	КонецЕсли;
	Элементы.КнопкаНазад.Видимость  = Ложь;
	Элементы.КнопкаДалее.Видимость  = Истина;
	Элементы.КнопкаДалее.КнопкаПоУмолчанию = Истина;
	Элементы.КнопкаГотово.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодготовитьСтраницуВводаЗадолженности()
	
	Элементы.НадписьВводЗадолженности.Видимость = Не ВводЗадолженности;
	
	ОтображатьВзносСДоходов = Не ЭтоИПНулевка // В Нулевке взносы с доходов не вводим.
		И (УплачиваетсяВзносПФРСДоходов       // Срок уплаты взносов с доходов за прошлый год еще не истек.
			Или ДолгПС_СвышеПредела <> 0);    // Долг по взносам с доходов ранее был введен пользователем, форма теста запущена повторно.
	
	Элементы.ДолгПС_СвышеПредела.Видимость = ОтображатьВзносСДоходов;
	Элементы.ЗаголовокВводЗадолженностиПостояннаяЧасть.Видимость = ОтображатьВзносСДоходов;
	
	Элементы.НадписьПС.Видимость = Не ПерешлиНаЕдиныйТариф;
	Элементы.НадписьМС.Видимость = Не ПерешлиНаЕдиныйТариф;
	Элементы.НадписьЕдиныйТариф.Видимость = ПерешлиНаЕдиныйТариф;
	
	Элементы.ДолгПС.Видимость = Не ПерешлиНаЕдиныйТариф;
	Элементы.ДолгМС.Видимость = Не ПерешлиНаЕдиныйТариф;
	Элементы.ДолгЕдиныйТариф.Видимость = ПерешлиНаЕдиныйТариф;
	
	Элементы.ПеняПС.Видимость = Не ПерешлиНаЕдиныйТариф;
	Элементы.ПеняМС.Видимость = Не ПерешлиНаЕдиныйТариф;
	Элементы.ПеняЕдиныйТариф.Видимость = ПерешлиНаЕдиныйТариф;
	
	Элементы.ШтрафПС.Видимость = Не ПерешлиНаЕдиныйТариф;
	Элементы.ШтрафМС.Видимость = Не ПерешлиНаЕдиныйТариф;
	Элементы.ШтрафЕдиныйТариф.Видимость = ПерешлиНаЕдиныйТариф;
	
	Элементы.КнопкаНазад.Видимость = Не ВводЗадолженности;
	Элементы.КнопкаДалее.Видимость  = Ложь;
	Элементы.КнопкаГотово.Видимость = Истина;
	Элементы.КнопкаГотово.КнопкаПоУмолчанию = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗаголовок()
	
	ИмяТекущейСтраницы = Элементы.ГруппаТест.ТекущаяСтраница.Имя;
	
	Если ВводЗадолженности И ИмяТекущейСтраницы = "ГруппаВводЗадолженности" Тогда
		Заголовок = НСтр("ru = 'Укажите задолженность из справки'");
		Возврат;
	КонецЕсли;
	
	// На первых этапах теста конечное число вопросов чаще всего неизвестно.
	ВсегоВопросов = Неопределено;
	
	// Опишем сценарии, когда число вопросов известно.
	Если ИмяТекущейСтраницы = "ГруппаВопрос2" И Не ЭтоИПНулевка Тогда
		ВсегоВопросов = 3;
	КонецЕсли;
	
	Если ИмяТекущейСтраницы = "ГруппаВопрос3" Тогда // Задается только в Нулевке.
		Если Переключатель3 = РезультатПодготовитьЗаявление() Тогда
			ВсегоВопросов = 3;
		Иначе
			ВсегоВопросов = 4;
		КонецЕсли;
	КонецЕсли;
	
	Если ИмяТекущейСтраницы = "ГруппаВводЗадолженности" Тогда
		ВсегоВопросов = 3;
	КонецЕсли;
	
	Если ИмяТекущейСтраницы = "ГруппаВопрос4" Тогда
		Если ЭтоИПНулевка Тогда
			ВсегоВопросов = 4;
		Иначе
			// В обычном режиме вопрос 3 пропускается.
			ВсегоВопросов = 3;
		КонецЕсли;
	КонецЕсли;
	
	Если ВсегоВопросов = Неопределено Тогда
		Заголовок = СтрШаблон(НСтр("ru = 'Шаг %1'"), НомерВопроса);
	Иначе
		Заголовок = СтрШаблон(НСтр("ru = 'Шаг %1 из %2'"), НомерВопроса, ВсегоВопросов);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьРезультатИЗавершитьТест(РезультатТестирования)
	
	Если РезультатТестирования = РезультатПолучитьСправку() Тогда // Запрос справки через 1С-Отчетность.
		ЗапроситьСправкуЧерезИнтернет();
	Иначе
		Если Не ПроверитьЗаполнение() Тогда
			НомерВопроса = НомерВопроса - 1;
			СледующийВопрос = "";
			Возврат;
		КонецЕсли;
		Результат = Новый Структура;
		Результат.Вставить("АдресСведенийОбОрганизации", АдресСведенийОбОрганизации);
		Результат.Вставить("РезультатТестирования",     РезультатТестирования);
		Результат.Вставить("ОплаченныеГоды",            ОплаченныеГоды);
		Результат.Вставить("Организация",               Организация);
		Результат.Вставить("КодЗадачи",                 КодЗадачи);
		Результат.Вставить("Период",                    Период);
		Результат.Вставить("ДолгПС",                    ДолгПС);
		Результат.Вставить("ДолгПС_СвышеПредела",       ДолгПС_СвышеПредела);
		Результат.Вставить("ПеняПС",                    ПеняПС);
		Результат.Вставить("ШтрафПС",                   ШтрафПС);
		Результат.Вставить("ДолгМС",                    ДолгМС);
		Результат.Вставить("ПеняМС",                    ПеняМС);
		Результат.Вставить("ШтрафМС",                   ШтрафМС);
		Результат.Вставить("ДолгЕдиныйТариф",           ДолгЕдиныйТариф);
		Результат.Вставить("ПеняЕдиныйТариф",           ПеняЕдиныйТариф);
		Результат.Вставить("ШтрафЕдиныйТариф",          ШтрафЕдиныйТариф);
		Результат.Вставить("ПерешлиНаЕдиныйТариф",      ПерешлиНаЕдиныйТариф);
		
		Если ЭтоИПНулевка Тогда
			ЗавершитьТестНулевка(Результат);
		Иначе
			ЗавершитьТестРегулярнаяДеятельность(Результат);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьТестРегулярнаяДеятельность(Результат)
	
	РезультатТестирования = Результат.РезультатТестирования;
	
	РегулярнаяДеятельностьОбработатьРезультатНаСервере(Результат);
	Оповестить("НалогиПрошлыхПериодов_ИзмененыОстатки",, Организация);
	
	Если ТипЗнч(ВладелецФормы) = Тип("ФормаКлиентскогоПриложения")
		И СтрНайти(ВладелецФормы.ИмяФормы, "ФормаОплатыЗаПрошлыеПериоды") > 0
		И ВладелецФормы.Открыта() Тогда
		
		ВладелецФормы.Активизировать();
	ИначеЕсли РезультатТестирования = РезультатЕстьДолги() Или РезультатТестирования = РезультатВведенаЗадолженность() Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Организация",              Организация);
		ПараметрыФормы.Вставить("Правило",                  Правило);
		
		ОткрытьФорму("Обработка.ПомощникУплатыНалоговВзносовПрошлыхЛет.Форма.ФормаОплатыЗаПрошлыеПериоды", ПараметрыФормы);
		
	КонецЕсли;
	
	Закрыть(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьТестНулевка(Результат)
	
	Если ТипЗнч(ВладелецФормы) = Тип("ФормаКлиентскогоПриложения")
		И СтрНайти(ВладелецФормы.ИмяФормы, "ФормаВзносыИПНулевка") > 0
		И ВладелецФормы.Открыта() Тогда
			
		ВладелецФормы.Активизировать();
	Иначе
		ОткрытьФорму("Обработка.РасчетСтраховыхВзносовИП.Форма.ФормаВзносыИПНулевка", Результат);
	КонецЕсли;
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура РегулярнаяДеятельностьОбработатьРезультатНаСервере(Результат)
	
	СохранитьНачальныеОстаткиПоВзносам(Результат);
	ЗаписатьОпросПройден(Результат);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьНачальныеОстаткиПоВзносам(Результат)
	
	ВидНалогаОМС = Перечисления.ВидыНалогов.ФиксированныеВзносы_ФФОМС;
	ВидНалогаПФР = Перечисления.ВидыНалогов.ФиксированныеВзносы_ПФР_СтраховаяЧасть;
	ВидНалогаЕдиныйТариф = Перечисления.ВидыНалогов.ФиксированныеВзносы_СтраховыеВзносыЕдиныйТариф;
	
	ТаблицаОстатков = ТаблицаОстатков(Результат.Организация, Результат.КодЗадачи, Результат.Период);
	Если Результат.РезультатТестирования = РезультатВведенаЗадолженность() Тогда
		
		// ПФР
		НайденныеСтроки = ТаблицаОстатков.НайтиСтроки(Новый Структура("ВидНалогаПоКлассификатору", ВидНалогаПФР));
		Для Каждого СтрокаОстатков Из НайденныеСтроки Цикл
			Если СтрокаОстатков.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.Налог Тогда
				СтрокаОстатков.Задолженность = Результат.ДолгПС;
			ИначеЕсли СтрокаОстатков.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.ПениСам Тогда
				СтрокаОстатков.Задолженность = Результат.ПеняПС;
			ИначеЕсли СтрокаОстатков.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.Штраф Тогда
				СтрокаОстатков.Задолженность = Результат.ШтрафПС;
			ИначеЕсли СтрокаОстатков.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.ВзносыСвышеПредела Тогда
				СтрокаОстатков.Задолженность = Результат.ДолгПС_СвышеПредела;
			КонецЕсли;
		КонецЦикла;
		
		// ОМС
		НайденныеСтроки = ТаблицаОстатков.НайтиСтроки(Новый Структура("ВидНалогаПоКлассификатору", ВидНалогаОМС));
		Для Каждого СтрокаОстатков Из НайденныеСтроки Цикл
			Если СтрокаОстатков.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.Налог Тогда
				СтрокаОстатков.Задолженность = Результат.ДолгМС;
			ИначеЕсли СтрокаОстатков.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.ПениСам Тогда
				СтрокаОстатков.Задолженность = Результат.ПеняМС;
			ИначеЕсли СтрокаОстатков.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.Штраф Тогда
				СтрокаОстатков.Задолженность = Результат.ШтрафМС;
			КонецЕсли;
		КонецЦикла;
		
		// Единый тариф
		НайденныеСтроки = ТаблицаОстатков.НайтиСтроки(Новый Структура("ВидНалогаПоКлассификатору", ВидНалогаЕдиныйТариф));
		Для Каждого СтрокаОстатков Из НайденныеСтроки Цикл
			Если СтрокаОстатков.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.Налог Тогда
				СтрокаОстатков.Задолженность = Результат.ДолгЕдиныйТариф;
			ИначеЕсли СтрокаОстатков.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.ПениСам Тогда
				СтрокаОстатков.Задолженность = Результат.ПеняЕдиныйТариф;
			ИначеЕсли СтрокаОстатков.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.Штраф Тогда
				СтрокаОстатков.Задолженность = Результат.ШтрафЕдиныйТариф;
			КонецЕсли;
		КонецЦикла;
		
	ИначеЕсли Результат.РезультатТестирования = РезультатЕстьДолги() Тогда
		СуммыДоходовПоДекларациям = Обработки.ПодготовкаОтчетностиПрошлыхПериодов.СуммыДоходовПрошлыхЛет(
			Результат.Организация, ЗадачиБухгалтераКлиентСервер.КодЗадачиУСН());
		ДолгПС = 0;
		ДолгМС = 0;
		ДолгЕдиныйТариф = 0;
		ВзносыСвышеПредела = 0;
		Для Каждого Год Из Результат.ОплаченныеГоды Цикл
			Если Год.Пометка Тогда
				Продолжить;
			КонецЕсли;
			ПериодНалога = Дата(Год.Значение, 1, 1);
			Периодичность = Перечисления.Периодичность.Год;
			ФиксированныеСтраховыеВзносыКУплате = УчетСтраховыхВзносовИП.ФиксированныеСтраховыеВзносыКУплате(
				Результат.Организация, ПериодНалога, Периодичность);
			Если Не Результат.ПерешлиНаЕдиныйТариф Тогда
				ДолгПС = ДолгПС + ФиксированныеСтраховыеВзносыКУплате.СуммаВзносаПФР;
				ДолгМС = ДолгМС + ФиксированныеСтраховыеВзносыКУплате.СуммаВзносаФФОМС;
			Иначе
				Если ЗначениеЗаполнено(ФиксированныеСтраховыеВзносыКУплате.СуммаВзносаЕдиныйТариф) Тогда
					ДолгЕдиныйТариф = ДолгЕдиныйТариф + ФиксированныеСтраховыеВзносыКУплате.СуммаВзносаЕдиныйТариф;
				Иначе
					ДолгЕдиныйТариф = ДолгЕдиныйТариф
						+ ФиксированныеСтраховыеВзносыКУплате.СуммаВзносаПФР
						+ ФиксированныеСтраховыеВзносыКУплате.СуммаВзносаФФОМС;
				КонецЕсли;
			КонецЕсли;
			
			СуммаДоходаПоДекларации = СуммыДоходовПоДекларациям.Получить(Год.Значение);
			// Суммы дополнительных взносов на ОПС.
			Если ЗначениеЗаполнено(СуммаДоходаПоДекларации) Тогда
				СтруктураДоходов = Новый Структура("СуммаДоходаИП, СуммаДоходаУСН, ВмененныйДоход, ПотенциальноВозможныйДоход", 0, 0, 0, 0);
				СтруктураДоходов.СуммаДоходаИП = СуммаДоходаПоДекларации;
				ДопВзносы = УчетСтраховыхВзносовИП.СтраховыеВзносыСДоходовКУплате(
					Результат.Организация, ПериодНалога, СтруктураДоходов, Ложь);
				ВзносыСвышеПредела = ВзносыСвышеПредела + ДопВзносы.СуммаВзносаПФРсДоходов;
			КонецЕсли;
		КонецЦикла;
		
		НайденныеСтроки = ТаблицаОстатков.НайтиСтроки(Новый Структура("ВидНалогаПоКлассификатору", ВидНалогаПФР));
		Для Каждого СтрокаОстатков Из НайденныеСтроки Цикл
			Если СтрокаОстатков.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.Налог Тогда
				СтрокаОстатков.Задолженность = ДолгПС;
			ИначеЕсли СтрокаОстатков.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.ВзносыСвышеПредела Тогда
				СтрокаОстатков.Задолженность = ВзносыСвышеПредела;
			КонецЕсли;
		КонецЦикла;
		
		НайденныеСтроки = ТаблицаОстатков.НайтиСтроки(Новый Структура("ВидНалогаПоКлассификатору", ВидНалогаОМС));
		Для Каждого СтрокаОстатков Из НайденныеСтроки Цикл
			Если СтрокаОстатков.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.Налог Тогда
				СтрокаОстатков.Задолженность = ДолгМС;
			КонецЕсли;
		КонецЦикла;
		
		НайденныеСтроки = ТаблицаОстатков.НайтиСтроки(Новый Структура("ВидНалогаПоКлассификатору", ВидНалогаЕдиныйТариф));
		Для Каждого СтрокаОстатков Из НайденныеСтроки Цикл
			Если СтрокаОстатков.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.Налог Тогда
				СтрокаОстатков.Задолженность = ДолгЕдиныйТариф;
			КонецЕсли;
		КонецЦикла;
	
	КонецЕсли;
	
	ПараметрыДляОбработки = Новый Структура;
	ПараметрыДляОбработки.Вставить("Организация",       Результат.Организация);
	ПараметрыДляОбработки.Вставить("ДатаВводаОстатков", Результат.Период);
	ПараметрыДляОбработки.Вставить("ТаблицаОстатков",   ТаблицаОстатков);
	
	Обработки.ПомощникУплатыНалоговВзносовПрошлыхЛет.ОтразитьЗадолженностьПоНалогамВзносам(
		ПараметрыДляОбработки, Неопределено);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТаблицаОстатков(Организация, КодЗадачи, Период)
	
	Результат = ПомощникиПоУплатеНалоговИВзносов.НоваяТаблицаИзмененияРасчетовПоНалогамВзносамИП();
	
	// Дополнительная колонка - для заполнения остатков в разрезе видов налогов из перечисления-классификатора.
	Результат.Колонки.Добавить("ВидНалогаПоКлассификатору", Новый ОписаниеТипов("ПеречислениеСсылка.ВидыНалогов"));
	
	Для Каждого ВидНалога Из Обработки.ПомощникУплатыНалоговВзносовПрошлыхЛет.ВидыНалоговПоКодуЗадачи(Организация, КодЗадачи) Цикл
		Налог = Справочники.ВидыНалоговИПлатежейВБюджет.НалогПоВиду(ВидНалога, Истина, Период);
		СчетУчета = Справочники.ВидыНалоговИПлатежейВБюджет.СчетУчета(Налог);
		Для Каждого ВидПлатежа Из ВидыПлатежей(ВидНалога) Цикл
			СтрокаТаблицы = Результат.Добавить();
			СтрокаТаблицы.ВидПлатежаВБюджет = ВидПлатежа;
			СтрокаТаблицы.СчетУчета = СчетУчета;
			СтрокаТаблицы.Задолженность = 0;
			СтрокаТаблицы.Переплата = 0;
			// В документе ВводНачальныхОстатков колонка ВидНалога заполняется элементами справочника налогов.
			СтрокаТаблицы.ВидНалога = Налог;
			СтрокаТаблицы.ВидНалогаПоКлассификатору = ВидНалога;
		КонецЦикла;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗаписатьОпросПройден(Результат)
	
	Обработки.ПомощникУплатыНалоговВзносовПрошлыхЛет.ЗаписатьТестПоНалогуПройден(
		Результат.Организация, Результат.КодЗадачи);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьСправкуЧерезИнтернет()
	
	ВидСверки = ПредопределенноеЗначение("Перечисление.ВидыУслугПриИОН.ПредставлениеСправкиОСостоянииРасчетовСБюджетом");
	ЭлектронныйДокументооборотСФНСКлиент.СоздатьЗапросНаСверкуСФНС(Организация, ВидСверки, Ложь);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция РезультатПолучитьСправку()
	
	Возврат "ПолучитьСправку";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция РезультатПрошлыеГодыОплачены()
	
	Возврат "ПрошлыеГодыОплачены";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция РезультатЕстьДолги()
	
	Возврат "ЕстьДолги";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция РезультатПодготовитьЗаявление()
	
	Возврат "ПодготовитьЗаявление";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция РезультатВведенаЗадолженность()
	
	Возврат "ВведенаЗадолженность";
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗапрошенаСправкаСохранитьСостояниеПомощника(Знач Организация, Знач ДокументЗапросаСправки)
	
	ДанныеРегистра = Новый Структура;
	ДанныеРегистра.Вставить("Организация",   Организация);
	ДанныеРегистра.Вставить("Состояние",     Перечисления.СостоянияПомощникаОплатыСтраховыхВзносовИП.ЗапрошенаСправкаОСостоянииРасчетов);
	ДанныеРегистра.Вставить("ЗапросСправки", ДокументЗапросаСправки);
	
	РегистрыСведений.СостоянияПомощникаОплатыСтраховыхВзносовИП.СохранитьСостояниеПомощника(ДанныеРегистра);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗадолженность()

	Если ЭтоИПНулевка Тогда
		Возврат;
	КонецЕсли;
	
	ВидНалогаПФР = Перечисления.ВидыНалогов.ФиксированныеВзносы_ПФР_СтраховаяЧасть;
	НачальныеОстатки = Обработки.ПомощникУплатыНалоговВзносовПрошлыхЛет.НачальныеОстаткиПоНалогам(Организация, Период);
	Для Каждого ВидНалога Из Обработки.ПомощникУплатыНалоговВзносовПрошлыхЛет.ВидыНалоговПоКодуЗадачи(Организация, КодЗадачи) Цикл
		НайденныеСтроки = НачальныеОстатки.НайтиСтроки(Новый Структура("ВидНалога", ВидНалога));
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			Если ВидНалога = Перечисления.ВидыНалогов.ФиксированныеВзносы_СтраховыеВзносыЕдиныйТариф Тогда
				Если НайденнаяСтрока.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.Налог Тогда
					ДолгЕдиныйТариф = НайденнаяСтрока.Задолженность;
				ИначеЕсли НайденнаяСтрока.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.ПениСам Тогда
					ПеняЕдиныйТариф = НайденнаяСтрока.Задолженность;
				ИначеЕсли НайденнаяСтрока.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.Штраф Тогда
					ШтрафЕдиныйТариф = НайденнаяСтрока.Задолженность;
				КонецЕсли;
			ИначеЕсли ВидНалога = ВидНалогаПФР Тогда
				Если НайденнаяСтрока.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.Налог Тогда
					ДолгПС = НайденнаяСтрока.Задолженность;
				ИначеЕсли НайденнаяСтрока.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.ВзносыСвышеПредела Тогда
					ДолгПС_СвышеПредела = НайденнаяСтрока.Задолженность;
				ИначеЕсли НайденнаяСтрока.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.ПениСам Тогда
					ПеняПС = НайденнаяСтрока.Задолженность;
				ИначеЕсли НайденнаяСтрока.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.Штраф Тогда
					ШтрафПС = НайденнаяСтрока.Задолженность;
				КонецЕсли;
			Иначе
				Если НайденнаяСтрока.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.Налог Тогда
					ДолгМС = НайденнаяСтрока.Задолженность;
				ИначеЕсли НайденнаяСтрока.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.ПениСам Тогда
					ПеняМС = НайденнаяСтрока.Задолженность;
				ИначеЕсли НайденнаяСтрока.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.Штраф Тогда
					ШтрафМС = НайденнаяСтрока.Задолженность;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВидыПлатежей(ВидНалога)
	
	Результат = Обработки.ПомощникУплатыНалоговВзносовПрошлыхЛет.ПоддерживаемыеВидыНалоговыхОбязательств();
	Если ВидНалога = Перечисления.ВидыНалогов.ФиксированныеВзносы_ПФР_СтраховаяЧасть
		Или ВидНалога = Перечисления.ВидыНалогов.ФиксированныеВзносы_СвышеПредела Тогда
		Результат.Добавить(Перечисления.ВидыПлатежейВГосБюджет.ВзносыСвышеПредела);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция УплачиваетсяВзносПФРСДоходов(СтраховойГод)
	
	СрокУплаты = УчетСтраховыхВзносовИП.СрокУплатыВзносовСвышеПредела(СтраховойГод);
	
	Возврат ТекущаяДатаСеанса() <= КонецДня(СрокУплаты);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.СообщениеТребуютсяРеквизиты.Видимость =
		(ЗначениеЗаполнено(Форма.Организация) И НЕ Форма.РеквизитыОрганизацииЗаполнены);
	
КонецПроцедуры

#Область ПроверкаРеквизитовДляОтчетности

&НаСервереБезКонтекста
Функция ПроверитьРеквизитыОрганизации(Организация)
	
	НезаполненныеРеквизиты = Неопределено;
	РеквизитыОрганизацииЗаполнены = ОрганизацииФормыДляОтчетности.РеквизитыЗаполнены(
		Организация, ПроверяемыеРеквизитыОрганизации(Организация), НезаполненныеРеквизиты);
		
	Возврат Новый Структура("РеквизитыЗаполнены, НезаполненныеРеквизиты", РеквизитыОрганизацииЗаполнены, НезаполненныеРеквизиты);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПроверяемыеРеквизитыОрганизации(Организация)
	
	Возврат ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("КодПоОКТМО");
	
КонецФункции

#КонецОбласти

#КонецОбласти
