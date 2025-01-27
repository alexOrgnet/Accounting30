﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОбработчикКоманды = ВариантОбработкиКоманды();
	Если ОбработчикКоманды.Вид = "СоздатьЗаявку" Тогда
		// Открываем форму создания новой заявки.
		ОткрытьФорму("Документ.ЗаявкаНаОткрытиеСчета.ФормаОбъекта",
			,
			ПараметрыВыполненияКоманды.Источник,
			,
			ПараметрыВыполненияКоманды.Окно, 
			ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	ИначеЕсли ОбработчикКоманды.Вид = "ОткрытьЗаявку" Тогда
		// Открываем форму заявки в состоянии "Черновик".
		ПараметрыОткрытияФормы = Новый Структура("Ключ", ОбработчикКоманды.Заявка);
		ОткрытьФорму("Документ.ЗаявкаНаОткрытиеСчета.ФормаОбъекта",
			ПараметрыОткрытияФормы,
			ПараметрыВыполненияКоманды.Источник,
			,
			ПараметрыВыполненияКоманды.Окно, 
			ПараметрыВыполненияКоманды.НавигационнаяСсылка
			);
	Иначе
		// Открываем форму списка.
		ОткрытьФорму("РегистрСведений.СостояниеЗаявокНаОткрытиеСчета.ФормаСписка",
			,
			ПараметрыВыполненияКоманды.Источник,
			,
			ПараметрыВыполненияКоманды.Окно, 
			ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ВариантОбработкиКоманды()
	
	ОбработчикКоманды = Новый Структура;
	ОбработчикКоманды.Вставить("Вид", "ОткрытьСписок");
	
	ЕстьПравоРедактирования = ПравоДоступа("Изменение", Метаданные.Документы.ЗаявкаНаОткрытиеСчета);
	
	Если Не ЕстьПравоРедактирования Тогда
		
		Возврат ОбработчикКоманды;
		
	КонецЕсли;

	ДоступныеОрганизации = ОбщегоНазначенияБПВызовСервераПовтИсп.ВсеОрганизацииДанныеКоторыхДоступныПоRLS(Ложь);
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	СостояниеЗаявокНаОткрытиеСчета.ЗаявкаНаОткрытиеСчета КАК Заявка,
		|	ВЫБОР
		|		КОГДА СостояниеЗаявокНаОткрытиеСчета.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияЗаявокНаОткрытиеСчета.Черновик)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК СостояниеЧерновик
		|ИЗ
		|	РегистрСведений.СостояниеЗаявокНаОткрытиеСчета КАК СостояниеЗаявокНаОткрытиеСчета
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаявкаНаОткрытиеСчета КАК ЗаявкаДокумент
		|		ПО СостояниеЗаявокНаОткрытиеСчета.ЗаявкаНаОткрытиеСчета = ЗаявкаДокумент.Ссылка
		|			И (НЕ ЗаявкаДокумент.ПометкаУдаления)
		|ГДЕ
		|	СостояниеЗаявокНаОткрытиеСчета.Организация В(&ДоступныеОрганизации)
		|	И СостояниеЗаявокНаОткрытиеСчета.ДатаИзменения > &НачалоПериода
		|
		|УПОРЯДОЧИТЬ ПО
		|	СостояниеЗаявокНаОткрытиеСчета.ДатаИзменения УБЫВ,
		|	СостояниеЧерновик УБЫВ";
	
	Запрос.УстановитьПараметр("ДоступныеОрганизации", ДоступныеОрганизации);
	
	ТекущаяДата = ТекущаяДатаСеанса();
	Запрос.УстановитьПараметр("НачалоПериода", ДобавитьМесяц(НачалоМесяца(ТекущаяДата), -6));
	
	РезультатЗапроса = Запрос.Выполнить();

	Если РезультатЗапроса.Пустой() Тогда
		
		ОбработчикКоманды.Вставить("Вид", "СоздатьЗаявку");
		Возврат ОбработчикКоманды;

	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Если Выборка.СостояниеЧерновик Тогда
		
		ОбработчикКоманды.Вставить("Вид",		"ОткрытьЗаявку");
		ОбработчикКоманды.Вставить("Заявка",	Выборка.Заявка);
		
	КонецЕсли;

	Возврат ОбработчикКоманды;

КонецФункции

#КонецОбласти
