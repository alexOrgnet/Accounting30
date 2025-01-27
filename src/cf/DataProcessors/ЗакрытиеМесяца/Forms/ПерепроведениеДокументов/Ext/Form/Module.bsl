﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВариантВосстановления = "ПерепровестиДокументы";
	
	Организация                         = Параметры.Организация;
	ПериодРегистрации                   = Параметры.ПериодРегистрации;
	ДокументНарушенияПоследовательности = Параметры.ДокументНарушенияПоследовательности;
	ДатаНарушенияПоследовательности     = Параметры.ДатаНарушенияПоследовательности;
	Если ЗначениеЗаполнено(ДатаНарушенияПоследовательности)
	   И Не ЗначениеЗаполнено(ДокументНарушенияПоследовательности) Тогда
		ДокументНарушенияПоследовательности = Документы.ВводНачальныхОстатков.ПустаяСсылка();
	КонецЕсли;
	ОбновитьПериодПерепроведения();

	ЕстьПравоПереносаГраницы = ЕстьПравоПереносаГраницы();
	
	Если Параметры.КлючНазначенияИспользования = "ПерепровестиДокументы" Тогда
		
		Заголовок = НСтр("ru = 'Перепроведение документов'");
		
		Если ДатаНарушенияПоследовательности < ПериодРегистрации Тогда
			
			Если Параметры.ЕстьОбособленныеПодразделения Тогда
				// Предлагаем перейти в месяц нарушения последовательности.
				ВариантВосстановления = "ПерейтиКМесяцу";
				Элементы.ВариантВосстановленияПерепровестиДокументы.СписокВыбора[0].Значение = "ПерейтиКМесяцу";
				ПредставлениеПункта = СтрШаблон(НСтр("ru = 'Перейти к закрытию месяца за %1 г.'"),
					ОбщегоНазначенияБПКлиентСервер.ФормаПадежаМесяца(ДатаНарушенияПоследовательности, 4));

			Иначе

				ПредставлениеПункта = СтрШаблон(НСтр("ru = 'Перепровести с %1 по %2'"),
					ОбщегоНазначенияБПКлиентСервер.ФормаПадежаМесяца(ДатаНарушенияПоследовательности, 2),
					ОбщегоНазначенияБПКлиентСервер.ФормаПадежаМесяца(ПериодРегистрации, 4));
					
			КонецЕсли;
			Элементы.ВариантВосстановленияПерепровестиДокументы.СписокВыбора[0].Представление = ПредставлениеПункта;	

			ПредставлениеПункта = СтрШаблон(НСтр("ru = 'Перепровести только %1'"),
				ОбщегоНазначенияБПКлиентСервер.ФормаПадежаМесяца(ПериодРегистрации, 4));
			Элементы.ВариантВосстановленияПерепровестиМесяц.СписокВыбора[0].Представление = ПредставлениеПункта;
			Элементы.ВариантВосстановленияПерепровестиМесяц.Доступность = ЕстьПравоПереносаГраницы;	

		Иначе

			ПредставлениеПункта = СтрШаблон(НСтр("ru = 'Перепровести %1'"),
				ОбщегоНазначенияБПКлиентСервер.ФормаПадежаМесяца(ПериодРегистрации, 4));
			Элементы.ВариантВосстановленияПерепровестиДокументы.СписокВыбора[0].Представление = ПредставлениеПункта;
			
			Элементы.ГруппаВариантВосстановленияПерепровестиМесяц.Видимость = Ложь;

		КонецЕсли;		

		Элементы.ВариантВосстановленияПеренестиГраницу.Доступность = ЕстьПравоПереносаГраницы;
		
		Если Не ЕстьПравоПереносаГраницы Тогда
			Элементы.ГруппаВариантВосстановления.Подсказка =
				НСтр("ru = 'Некоторые варианты перепроведения доступны только главному бухгалтеру'");
			Элементы.ГруппаВариантВосстановления.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
		КонецЕсли;
		
	ИначеЕсли Параметры.КлючНазначенияИспользования = "ПомощникРасчетаНДС" Тогда
		
		Заголовок = НСтр("ru = 'Перепроведение документов'");
		
		Если ДатаНарушенияПоследовательности < НачалоКвартала(ПериодРегистрации) Тогда
			
			ТекстРекомендации = НСтр("ru = 'Рекомендуется перепровести с %1 г.
									|'");
			ТекстРекомендации = СтрШаблон(ТекстРекомендации,
				ОбщегоНазначенияБПКлиентСервер.ФормаПадежаМесяца(ДатаНарушенияПоследовательности, 2));
			Элементы.ДекорацияПериодПерепроведения.Заголовок = Новый ФорматированнаяСтрока(
				ТекстРекомендации,
				Элементы.ДекорацияПериодПерепроведения.Заголовок);
				
		КонецЕсли;
		
		Элементы.ГруппаВариантВосстановленияПерепровестиМесяц.Видимость = Ложь;
		
		Если ДатаНарушенияПоследовательности < НачалоКвартала(ПериодРегистрации) Тогда
			
			ПредставлениеПункта = СтрШаблон(НСтр("ru = 'Перепровести с %1 по %2'"),
				ОбщегоНазначенияБПКлиентСервер.ФормаПадежаМесяца(ДатаНарушенияПоследовательности, 2),
				ОбщегоНазначенияБПКлиентСервер.ФормаПадежаМесяца(ПериодРегистрации, 4));
			Элементы.ВариантВосстановленияПерепровестиДокументы.СписокВыбора[0].Представление = ПредставлениеПункта;

			Элементы.ГруппаВариантВосстановленияПерепровестиКвартал.Видимость = Истина;
			
			ПредставлениеПериода = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(
				НачалоКвартала(ПериодРегистрации), КонецКвартала(ПериодРегистрации), Истина);
			ПредставлениеПункта = СтрШаблон(НСтр("ru = 'Перепровести только %1'"), ПредставлениеПериода);
			Элементы.ВариантВосстановленияПерепровестиКвартал.СписокВыбора[0].Представление = ПредставлениеПункта;
			
			Элементы.ВариантВосстановленияПерепровестиКвартал.Доступность = ЕстьПравоПереносаГраницы;

		Иначе

			ПредставлениеПериода = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(
				НачалоКвартала(ПериодРегистрации), КонецКвартала(ПериодРегистрации), Истина);
			ПредставлениеПункта = СтрШаблон(НСтр("ru = 'Перепровести %1'"), ПредставлениеПериода);
			Элементы.ВариантВосстановленияПерепровестиДокументы.СписокВыбора[0].Представление = ПредставлениеПункта;

			Элементы.ГруппаВариантВосстановленияПерепровестиКвартал.Видимость = Ложь;
			
		КонецЕсли;
		
		Элементы.ВариантВосстановленияПеренестиГраницу.Доступность = ЕстьПравоПереносаГраницы;

		Если ЕстьПравоПереносаГраницы Тогда
			Элементы.ДекорацияПеренестиГраницу.Подсказка =
				НСтр("ru = 'Проводки документов до конца текущего квартала будут считаться корректными.'");
		Иначе
			Элементы.ГруппаВариантВосстановления.Подсказка =
				НСтр("ru = 'Некоторые варианты перепроведения доступны только главному бухгалтеру'");
			Элементы.ГруппаВариантВосстановления.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
		КонецЕсли;
		
	Иначе // закрытие месяца, требующее актуализации предыдущих месяцев
		
		Заголовок = НСтр("ru = 'Закрытие месяца'");
		
		ДокументНарушенияПоследовательности = Документы.ВводНачальныхОстатков.ПустаяСсылка();
		ТекстРекомендации = НСтр("ru = 'Рекомендуется закрыть период с %1.
									|'");
		ТекстРекомендации = СтрШаблон(ТекстРекомендации, 
			ОбщегоНазначенияБПКлиентСервер.ФормаПадежаМесяца(ДатаНарушенияПоследовательности, 2));
		Элементы.ДекорацияПериодПерепроведения.Заголовок = Новый ФорматированнаяСтрока(
			ТекстРекомендации,
			Элементы.ДекорацияПериодПерепроведения.Заголовок);
			
		Если ДатаНарушенияПоследовательности < ПериодРегистрации Тогда
			
			Если Параметры.ЕстьОбособленныеПодразделения Тогда
				
				// Предлагаем перейти в месяц нарушения последовательности.
				ВариантВосстановления = "ПерейтиКМесяцу";
				Элементы.ВариантВосстановленияПерепровестиДокументы.СписокВыбора[0].Значение = "ПерейтиКМесяцу";
				ПредставлениеПункта = СтрШаблон(НСтр("ru = 'Перейти к закрытию месяца за %1 г.'"),
					ОбщегоНазначенияБПКлиентСервер.ФормаПадежаМесяца(ДатаНарушенияПоследовательности, 4));
				
			Иначе
					
				ПредставлениеПункта = СтрШаблон(НСтр("ru = 'Закрыть с %1 по %2'"),
				    ОбщегоНазначенияБПКлиентСервер.ФормаПадежаМесяца(ДатаНарушенияПоследовательности, 2),
					ОбщегоНазначенияБПКлиентСервер.ФормаПадежаМесяца(ПериодРегистрации, 4));
				
			КонецЕсли;
			Элементы.ВариантВосстановленияПерепровестиДокументы.СписокВыбора[0].Представление = ПредставлениеПункта;	

		Иначе
			
			// Ситуация, когда нужно закрыть только текущий месяц, не требует выбора в диалоге: закрытие начинается сразу.
			// Поэтому такой вариант здесь не учитываем.
			ВызватьИсключение "Некорректное использование формы для данного ключа назначения использования";

		КонецЕсли;		
		
		ПредставлениеПункта = СтрШаблон(НСтр("ru = 'Закрыть только %1'"),
			ОбщегоНазначенияБПКлиентСервер.ФормаПадежаМесяца(ПериодРегистрации, 4));
		Элементы.ВариантВосстановленияПерепровестиМесяц.СписокВыбора[0].Представление = ПредставлениеПункта;
		Элементы.ВариантВосстановленияПерепровестиМесяц.Доступность = ЕстьПравоПереносаГраницы;
		Элементы.ДекорацияПерепровестиМесяц.Подсказка
			= НСтр("ru = 'Все предыдущие месяцы будут считаться уже закрытыми. Закрываться будет только текущий месяц.'");
		
		Элементы.ГруппаВариантВосстановленияПеренестиГраницу.Видимость = Ложь;
		
		Если Не ЕстьПравоПереносаГраницы Тогда
			Элементы.ГруппаВариантВосстановления.Подсказка =
				НСтр("ru = 'Некоторые варианты закрытия доступны только главному бухгалтеру'");
			Элементы.ГруппаВариантВосстановления.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
		КонецЕсли;
		
		// Форма в достаточной степени информирует о возможности закрывать сразу несколько периодов. Считаем, что
		// подсказка на форме "Закрытие месяца" пока больше не требуется.
		Если ЗакрытиеМесяца.НастройкаПодсказки(ЗакрытиеМесяца.КлючиНастройкиПодсказки().СобранаСтатистика) = Неопределено
			И ЗакрытиеМесяца.НастройкаПодсказки(ЗакрытиеМесяца.КлючиНастройкиПодсказки().ПоказатьЭлементыПодсказки) <> Неопределено Тогда
			Если ЗакрытиеМесяца.НастройкаПодсказки(ЗакрытиеМесяца.КлючиНастройкиПодсказки().ПодсказкаПоказана) <> Неопределено Тогда
				ЗакрытиеМесяца.ЗаписатьСтатистику("ПоказанаПодсказкаЗакрытоНесколькоПериодов");
			Иначе
				ЗакрытиеМесяца.УстановитьНастройкуПодсказки(ЗакрытиеМесяца.КлючиНастройкиПодсказки().ПодсказкаПоказана, Ложь);
			КонецЕсли;
			ЗакрытиеМесяца.УстановитьНастройкуПодсказки(ЗакрытиеМесяца.КлючиНастройкиПодсказки().СобранаСтатистика, Истина);
		КонецЕсли;
		ЗакрытиеМесяца.УстановитьНастройкуПодсказки(ЗакрытиеМесяца.КлючиНастройкиПодсказки().ПоказатьЭлементыПодсказки, Ложь);
		
	КонецЕсли;
	
	Если ВариантВосстановления = "ПеренестиГраницу" Тогда // перепроведение не требуется
		
		Элементы.ГруппаСхемаВарианта.Видимость = Ложь;
		
	Иначе
		
		ОтобразитьСхемуВарианта(ЭтотОбъект);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

&НаКлиенте
Процедура ОК(Команда)
	
	Если (ВариантВосстановления = "ПерепровестиМесяц"
		Или ВариантВосстановления = "ПеренестиГраницу")
	   И Не ЕстьПравоПереносаГраницы() Тогда
		
		ТекстПредупреждения = НСтр("ru = 'Признавать документы корректными без перепроведения может только пользователь
										|с ролью ""Право интерактивного переноса границы последовательности"".'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
		
	КонецЕсли;
	
	ПараметрыВосстановления = Новый Структура;
	ПараметрыВосстановления.Вставить("КлючНазначенияИспользования",     КлючНазначенияИспользования);
	ПараметрыВосстановления.Вставить("Организация",                     Организация);
	ПараметрыВосстановления.Вставить("ДатаНарушенияПоследовательности", ДатаНарушенияПоследовательности);
	ПараметрыВосстановления.Вставить("ВариантВосстановления",           ВариантВосстановления);
		
	Закрыть(ПараметрыВосстановления);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиЭлементовФормы

&НаКлиенте
Процедура ДекорацияПериодПерепроведенияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Организация",                     Организация);
	ПараметрыОтчета.Вставить("ДатаНарушенияПоследовательности", ДатаНарушенияПоследовательности);
	ПараметрыОтчета.Вставить("КонецПериодаКорректности",        КонецМесяца(ПериодРегистрации));
	
	ПараметрыКоманды = Новый Массив;
	ПараметрыКоманды.Добавить(ДокументНарушенияПоследовательности);
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("ЗаголовокФормы",          НСтр("ru = 'Отчет об измененных документах'"));
	ПараметрыПечати.Вставить("ДополнительныеПараметры", ПараметрыОтчета);

	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Обработка.ЗакрытиеМесяца",
		"ПерепроведенныеДокументы", 
		ПараметрыКоманды,
		ЭтотОбъект,
		ПараметрыПечати);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантВосстановленияПерепровестиДокументыПриИзменении(Элемент)
	
	ОтобразитьСхемуВарианта(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантВосстановленияПерепровестиМесяцПриИзменении(Элемент)
	
	ОтобразитьСхемуВарианта(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантВосстановленияПеренестиГраницуПриИзменении(Элемент)
	
	ОтобразитьСхемуВарианта(ЭтотОбъект);	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьПериодПерепроведения()
	
	// Подсчет числа документов-причин неактуальности.
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Сводный.Регистратор) КАК КоличествоИзмененных
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДокументыОрганизаций.Регистратор КАК Регистратор
	|	ИЗ
	|		Последовательность.ДокументыОрганизаций КАК ДокументыОрганизаций
	|	ГДЕ
	|		ДокументыОрганизаций.Организация = &Организация
	|		И ДокументыОрганизаций.СостояниеПроведения В (ЗНАЧЕНИЕ(Перечисление.СостоянияПроведенияВПоследовательности.ПроведенСНарушениемПоследовательности), ЗНАЧЕНИЕ(Перечисление.СостоянияПроведенияВПоследовательности.ИсключенИзПоследовательности))
	|		И ДокументыОрганизаций.Период МЕЖДУ &ДатаНарушенияПоследовательности И &КонецПериодаКорректности
	|	
	|	ОБЪЕДИНИТЬ
	|	
	|	ВЫБРАТЬ
	|		РасчетыСКонтрагентамиОтложенноеПроведение.Документ
	|	ИЗ
	|		РегистрСведений.РасчетыСКонтрагентамиОтложенноеПроведение КАК РасчетыСКонтрагентамиОтложенноеПроведение
	|	ГДЕ
	|		РасчетыСКонтрагентамиОтложенноеПроведение.Организация = &Организация
	|		И РасчетыСКонтрагентамиОтложенноеПроведение.СостояниеРасчетов В (ЗНАЧЕНИЕ(Перечисление.СостоянияОтложенныхРасчетов.КВыполнению), ЗНАЧЕНИЕ(Перечисление.СостоянияОтложенныхРасчетов.КИсключениюИзРасчетов))
	|		И РасчетыСКонтрагентамиОтложенноеПроведение.Дата МЕЖДУ &ДатаНарушенияПоследовательности И &КонецПериодаКорректности) КАК Сводный");
	Запрос.УстановитьПараметр("Организация",                     Организация);
	Запрос.УстановитьПараметр("ДатаНарушенияПоследовательности", ДатаНарушенияПоследовательности);
	Запрос.УстановитьПараметр("КонецПериодаКорректности",        КонецМесяца(ПериодРегистрации));
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И ЗначениеЗаполнено(Выборка.КоличествоИзмененных) Тогда

		// <a> - места начала и конца ссылки на отчёт по измененным документам
		КоличествоИзмененных = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(
			НСтр("ru=';был изменен <a>%1 документ</a>;;было изменено <a>%1 документа</a>;было изменено <a>%1 документов</a>;'"),
			Выборка.КоличествоИзмененных,
			,
			"ЧДЦ=0");
		
		ПериодПерепроведенияПредставление =	НСтр("ru = 'С %1 %2.'");
		ПериодПерепроведенияПредставление = СтрШаблон(ПериодПерепроведенияПредставление,
			Формат(ДатаНарушенияПоследовательности, "ДЛФ=DD"),
			КоличествоИзмененных);
			
		НачалоСсылки = СтрНайти(ПериодПерепроведенияПредставление, "<a>", НаправлениеПоиска.СНачала, , 1);
		Если НачалоСсылки <> 0 Тогда
			КонецСсылки = СтрНайти(ПериодПерепроведенияПредставление, "</a>", НаправлениеПоиска.СКонца, , 1);
			ПериодПерепроведенияПредставление = СтрЗаменить(ПериодПерепроведенияПредставление, "</a>", "");
			ПериодПерепроведенияПредставление = СтрЗаменить(ПериодПерепроведенияПредставление, "<a>", "");
			КонецСсылки = КонецСсылки - 3;
			ПериодПерепроведенияПредставление = Новый ФорматированнаяСтрока(
				Новый ФорматированнаяСтрока(Лев(ПериодПерепроведенияПредставление, НачалоСсылки - 1)),
				Новый ФорматированнаяСтрока(Сред(ПериодПерепроведенияПредставление, НачалоСсылки, КонецСсылки - НачалоСсылки),
					,,, "e1cib/app/Обработка.ЗакрытиеМесяца.Форма.ПерепроведениеДокументов"),
				Новый ФорматированнаяСтрока(Сред(КоличествоИзмененных, КонецСсылки)));
		КонецЕсли;
				
		Элементы.ДекорацияПериодПерепроведения.Заголовок = ПериодПерепроведенияПредставление;
		
	Иначе
		
		ПериодПерепроведенияПредставление =	НСтр("ru = 'С %1 выполнялись регламентные операции.'");
		ПериодПерепроведенияПредставление = СтрШаблон(ПериодПерепроведенияПредставление,
			НРег(Формат(ДатаНарушенияПоследовательности, "ДЛФ=DD")));
		Элементы.ДекорацияПериодПерепроведения.Заголовок = Новый ФорматированнаяСтрока(ПериодПерепроведенияПредставление);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОтобразитьСхемуВарианта(Форма)
	
	Форма.НадписьДатаНарушения = "   " + Формат(Форма.ДатаНарушенияПоследовательности, "ДЛФ=D");
	Форма.НадписьПериодРегистрации = Формат(КонецМесяца(Форма.ПериодРегистрации), "ДЛФ=D");
	Если Форма.ВариантВосстановления = "ПеренестиГраницу" Тогда
		
		Форма.Элементы.ДекорацияСхемаВарианта.Картинка = БиблиотекаКартинок.ПеренестиГраницу;
		
	ИначеЕсли Форма.ВариантВосстановления = "ПерепровестиКвартал" Тогда
		
		Форма.Элементы.ДекорацияСхемаВарианта.Картинка = БиблиотекаКартинок.ПерепровестиМесяц;
		Форма.НадписьПериодРегистрации = Формат(НачалоКвартала(Форма.ПериодРегистрации), "ДЛФ=D")
			#Если ВебКлиент Тогда
				+ Символы.Таб + Символы.Таб
			#Иначе
				+ Символы.Таб + Символы.Таб + Символы.Таб
			#КонецЕсли
			+ Форма.НадписьПериодРегистрации;
			
	ИначеЕсли Форма.ВариантВосстановления = "ПерепровестиМесяц" Тогда
		
		Форма.Элементы.ДекорацияСхемаВарианта.Картинка = БиблиотекаКартинок.ПерепровестиМесяц;
		Форма.НадписьПериодРегистрации = Формат(Форма.ПериодРегистрации, "ДЛФ=D")
			#Если ВебКлиент Тогда
				+ Символы.Таб + Символы.Таб
			#Иначе
				+ Символы.Таб + Символы.Таб + Символы.Таб
			#КонецЕсли
			+ Форма.НадписьПериодРегистрации;
		
	ИначеЕсли Форма.ВариантВосстановления = "ПерепровестиДокументы" Тогда
		
		Форма.Элементы.ДекорацияСхемаВарианта.Картинка = БиблиотекаКартинок.ПерепровестиДокументы;
		
	Иначе // ВариантВосстановления = "ПерейтиКМесяцу"
		
		Форма.Элементы.ДекорацияСхемаВарианта.Картинка = БиблиотекаКартинок.ПерейтиКМесяцу;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЕстьПравоПереносаГраницы()
	
	Возврат Пользователи.РолиДоступны("ПравоИнтерактивногоПереносаГраницыПоследовательности");
	
КонецФункции

#КонецОбласти
