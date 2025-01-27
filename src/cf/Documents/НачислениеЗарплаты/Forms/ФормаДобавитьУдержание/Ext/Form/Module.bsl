﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// "Распаковываем" параметры
	ПараметрыРасчета = ПолучитьИзВременногоХранилища(Параметры.АдресПараметровВХранилище);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыРасчета, "Ссылка, Организация, МесяцНачисления, Сотрудник, ФизическоеЛицо, Удержание");
	
	КадровыеДанныеФизЛиц = КадровыйУчет.КадровыеДанныеФизическихЛиц(Истина, ФизическоеЛицо, "ФамилияИО", МесяцНачисления);
	
	ПредставлениеСотрудника = КадровыеДанныеФизЛиц[0].ФамилияИО;
	
	Новое = НЕ ЗначениеЗаполнено(Удержание);
	Элементы.Наименование.Видимость = Новое;
	Если Новое Тогда
		Кратность = 3;
	Иначе
		Элементы.Сумма.Заголовок = Строка(Удержание);
		ДлинаНаименования = СтрДлина(Строка(Удержание));
		Кратность = Окр(ДлинаНаименования/10, 0, РежимОкругления.Окр15как20);
	КонецЕсли;
	Ширина = 10+10*Кратность;
	
	КлючСохраненияПоложенияОкна = "ПоложениеОкна" + Строка(Кратность);
	
	Заголовок = СтрШаблон(НСтр("ru='Удержание (%1)'"), ПредставлениеСотрудника);
	
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
		Оповестить("ДобавленоУдержание", ПоместитьИзмененныеДанныеВоВременноеХранилище(), ЭтотОбъект);
		Модифицированность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция Удержание()
	
	Если Новое Тогда
		НовоеУдержание = ПланыВидовРасчета.Удержания.СоздатьВидРасчета();
		НовоеУдержание.Наименование       = Наименование;
		НовоеУдержание.КатегорияУдержания = Перечисления.КатегорииУдержаний.ИсполнительныйЛист;
		НовоеУдержание.Записать();
		Удержание = НовоеУдержание.Ссылка;
	КонецЕсли;
	
	Возврат Удержание;
	
КонецФункции

&НаСервере
Функция ПоместитьИзмененныеДанныеВоВременноеХранилище()
	
	ВозвращаемыеСведения = Новый Структура;
	
	ДанныеУдержания = Новый Структура();
	ДанныеУдержания.Вставить("Сотрудник",          ФизическоеЛицо);
	ДанныеУдержания.Вставить("Удержание",          Удержание());
	ДанныеУдержания.Вставить("Результат",          Результат);
	ДанныеУдержания.Вставить("Контрагент",         Контрагент);
	ДанныеУдержания.Вставить("КатегорияУдержания", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Удержание, "КатегорияУдержания"));
	
	ВозвращаемыеСведения.Вставить("Удержание",      ДанныеУдержания);
	ВозвращаемыеСведения.Вставить("ФизическоеЛицо", ФизическоеЛицо);
	ВозвращаемыеСведения.Вставить("Сотрудник",      Сотрудник);
	
	Возврат ПоместитьВоВременноеХранилище(ВозвращаемыеСведения, Новый УникальныйИдентификатор);
	
КонецФункции

#КонецОбласти
