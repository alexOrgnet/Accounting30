﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// "Распаковываем" параметры
	ПараметрыРасчета = ПолучитьИзВременногоХранилища(Параметры.АдресПараметровВХранилище);

	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыРасчета, "Ссылка, Организация, Подразделение, МесяцНачисления, Сотрудник, ФизическоеЛицо, Начисление, ДатаВыплатыДохода");
	
	КадровыеДанные = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Сотрудник, "ФамилияИО, ДатаУвольнения");
	ДатаУвольнения = КадровыеДанные[0].ДатаУвольнения;
	Если ЗначениеЗаполнено(ДатаУвольнения)
		И НачалоМесяца(ДатаУвольнения) = МесяцНачисления Тогда
		ДатаВыплатыДохода = ДатаУвольнения;
	КонецЕсли;
	ПредставлениеСотрудника = КадровыеДанные[0].ФамилияИО;
	
	Новое = НЕ ЗначениеЗаполнено(Начисление);
	Элементы.Наименование.Видимость = Новое;
	Если Новое Тогда
		Кратность = 3;
	Иначе
		Элементы.Сумма.Заголовок = Строка(Начисление);
		ДлинаНаименования = СтрДлина(Строка(Начисление));
		Кратность = Окр(ДлинаНаименования/10, 0, РежимОкругления.Окр15как20);
	КонецЕсли;
	Ширина = 13+10*Кратность;
	
	КлючСохраненияПоложенияОкна = "ПоложениеОкна" + Строка(Кратность);
	
	Заголовок = СтрШаблон(НСтр("ru='Начисление (%1)'"), ПредставлениеСотрудника);
	
	Если НЕ ЗначениеЗаполнено(Подразделение) Тогда
		ЗначенияПоУмолчанию = Новый Структура("Организация, Подразделение");
		ЗарплатаКадры.ПолучитьЗначенияПоУмолчанию(ЗначенияПоУмолчанию);
		Подразделение = ЗначенияПоУмолчанию.Подразделение;
	КонецЕсли;
	
	СоответствиеКодовВычетовКодамДоходов = Новый ФиксированноеСоответствие(УчетНДФЛ.ВычетыКДоходам(Год(МесяцНачисления)));
	
	КодДоходаНДФЛ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Начисление, "КодДоходаНДФЛ");
	ВычетПримененныйКДоходам = Ложь;
	Если ЗначениеЗаполнено(КодДоходаНДФЛ) Тогда
		ВычетПримененныйКДоходам = ЭтотОбъект.СоответствиеКодовВычетовКодамДоходов.Получить(КодДоходаНДФЛ) <> Неопределено
	КонецЕсли;
	
	Если ВычетПримененныйКДоходам Тогда
		
		КодВычета = УчетНДФЛ.КодВычетаПоКодуДоходаНДФЛ(КодДоходаНДФЛ);
		
		Если ЗначениеЗаполнено(КодВычета) Тогда
			СуммаВычета = УчетНДФЛ.ВычетКДоходуСотрудника(
			Ссылка,
			Организация,
			МесяцНачисления,
			Сотрудник,
			КодДоходаНДФЛ,
			КодВычета,
			Результат,
			1);
			
			Элементы.КодВычета.ТолькоПросмотр = Истина;
			
		КонецЕсли;
		
	Иначе
		
		Элементы.ГруппаВычет.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СуммаПриИзменении(Элемент)
	
	ОбработатьИзменениеНачислений();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ПеренестиИзмененияВОбъектФормыВладельца();
	Закрыть(Сотрудник);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПеренестиИзмененияВОбъектФормыВладельца()
	
	Если Модифицированность Тогда
		Оповестить("ДобавленоНачисление", ПоместитьИзмененныеДанныеВоВременноеХранилище(), ЭтотОбъект);
		Модифицированность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеНачислений()
	
	КодДоходаНДФЛ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Начисление, "КодДоходаНДФЛ");
	
	Если ЗначениеЗаполнено(КодДоходаНДФЛ) Тогда
		ВычетПримененныйКДоходам = ЭтотОбъект.СоответствиеКодовВычетовКодамДоходов.Получить(КодДоходаНДФЛ) <> Неопределено
	КонецЕсли;
	
	Если ВычетПримененныйКДоходам Тогда
		КодВычета = УчетНДФЛ.КодВычетаПоКодуДоходаНДФЛ(КодДоходаНДФЛ);
		Если Не ЗначениеЗаполнено(КодВычета) Тогда
			КодВычета = УчетНДФЛ.КодВычетаПоКодуДоходаНДФЛ(КодДоходаНДФЛ);
		КонецЕсли;
	Иначе
		КодВычета = Справочники.ВидыВычетовНДФЛ.ПустаяСсылка();
		СуммаВычета = 0;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КодВычета) И СуммаВычета = 0 Тогда
		СуммаВычета = УчетНДФЛ.ВычетКДоходуСотрудника(
									Ссылка,
									Организация,
									МесяцНачисления,
									Сотрудник,
									КодДоходаНДФЛ,
									КодВычета,
									Результат,
									1);
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Функция Начисление()
	
	Если Новое Тогда
		НовоеНачисление = ПланыВидовРасчета.Начисления.СоздатьВидРасчета();
		НовоеНачисление.Наименование                               = Наименование;
		НовоеНачисление.КатегорияНачисленияИлиНеоплаченногоВремени = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.Прочее;
		НовоеНачисление.ВидНачисленияДляНУ                         = Перечисления.ВидыНачисленийОплатыТрудаДляНУ.пп2ст255;
		НовоеНачисление.КодДоходаНДФЛ                              = Справочники.ВидыДоходовНДФЛ.КодДоходаПоУмолчанию;
		НовоеНачисление.КодДоходаСтраховыеВзносы                   = Справочники.ВидыДоходовПоСтраховымВзносам.ОблагаетсяЦеликом;
		НовоеНачисление.КодДоходаСтраховыеВзносы2017               = Справочники.ВидыДоходовПоСтраховымВзносам.ОблагаетсяЦеликом;
		НовоеНачисление.ВходитВБазуРКИСН                           = Истина;
		НовоеНачисление.ВидОперацииПоЗарплате                      = Перечисления.ВидыОперацийПоЗарплате.НачисленоДоход;
		Если РасчетЗарплатыДляНебольшихОрганизаций.ОрганизацияПрименяетАУСН(Организация, МесяцНачисления) Тогда
			НовоеНачисление.КатегорияДохода = Перечисления.КатегорииДоходовНДФЛ.ОплатаТрудаАУСН;
		Иначе
			НовоеНачисление.КатегорияДохода = Перечисления.КатегорииДоходовНДФЛ.ОплатаТруда;
		КонецЕсли;
		НовоеНачисление.ВидДоходаИсполнительногоПроизводства2022 = Перечисления.ВидыДоходовИсполнительногоПроизводства.ЗарплатаВознаграждения;
		НовоеНачисление.Записать();
		Начисление = НовоеНачисление.Ссылка;
	КонецЕсли;
	
	Возврат Начисление;
	
КонецФункции

&НаСервере
Функция ПоместитьИзмененныеДанныеВоВременноеХранилище()
	
	ВозвращаемыеСведения = Новый Структура;
	
	ДанныеНачисления = Новый Структура();
	ДанныеНачисления.Вставить("Подразделение",            Подразделение);
	ДанныеНачисления.Вставить("Сотрудник",                Сотрудник);
	ДанныеНачисления.Вставить("ФизическоеЛицо",           ФизическоеЛицо);
	ДанныеНачисления.Вставить("Начисление",               Начисление());
	ДанныеНачисления.Вставить("Результат",                Результат);
	ДанныеНачисления.Вставить("КодВычета",                КодВычета);
	ДанныеНачисления.Вставить("СуммаВычета",              СуммаВычета);
	ДанныеНачисления.Вставить("ВычетПримененныйКДоходам", ВычетПримененныйКДоходам ИЛИ ЗначениеЗаполнено(КодВычета));
	ДанныеНачисления.Вставить("ВходитВБазуРКиСН",         ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Начисление, "ВходитВБазуРКИСН"));
	ДанныеНачисления.Вставить("ПланируемаяДатаВыплаты",   ДатаВыплатыДохода);
	
	ВозвращаемыеСведения.Вставить("Начисление",     ДанныеНачисления);
	ВозвращаемыеСведения.Вставить("ФизическоеЛицо", ФизическоеЛицо);
	ВозвращаемыеСведения.Вставить("Сотрудник",      Сотрудник);
	
	Возврат ПоместитьВоВременноеХранилище(ВозвращаемыеСведения, Новый УникальныйИдентификатор);
	
КонецФункции

#КонецОбласти
