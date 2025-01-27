﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов


////////////////////////////////////////////////////////////////////////////////
// ПОДГОТОВКА ПАРАМЕТРОВ ПРОВЕДЕНИЯ ДОКУМЕНТА
//

Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт

	ПараметрыПроведения = Новый Структура;

	МВТ    = Новый МенеджерВременныхТаблиц;
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МВТ;
	Запрос.УстановитьПараметр("Ссылка",      ДокументСсылка);
	Запрос.УстановитьПараметр("Организация", ДокументСсылка.Организация);
	Запрос.Текст = "ВЫБРАТЬ
	               |	УстановкаПорядкаЗакрытие.Подразделение КАК Подразделение,
	               |	УстановкаПорядкаЗакрытие.НомерСтроки КАК НомерПередела
	               |ПОМЕСТИТЬ ВТ_ПорядокЗакрытия
	               |ИЗ
	               |	Документ.УстановкаПорядкаЗакрытияПодразделений.ПорядокЗакрытия КАК УстановкаПорядкаЗакрытие
	               |ГДЕ
	               |	УстановкаПорядкаЗакрытие.Ссылка = &Ссылка
	               |
	               |ИНДЕКСИРОВАТЬ ПО
	               |	Подразделение,
	               |	УстановкаПорядкаЗакрытие.НомерСтроки
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Подразделения.Ссылка КАК Подразделение,
	               |	ВЫБОР
	               |		КОГДА ВТ_ПорядокЗакрытия.НомерПередела ЕСТЬ NULL 
	               |			ТОГДА 0
	               |		ИНАЧЕ ВТ_ПорядокЗакрытия.НомерПередела
	               |	КОНЕЦ КАК НомерПередела
	               |ИЗ
	               |	Справочник.ПодразделенияОрганизаций КАК Подразделения
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ПорядокЗакрытия КАК ВТ_ПорядокЗакрытия
	               |		ПО Подразделения.Ссылка = ВТ_ПорядокЗакрытия.Подразделение
	               |ГДЕ
	               |	(НЕ Подразделения.ПометкаУдаления)
	               |	И Подразделения.Владелец = &Организация
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	НомерПередела
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	УстановкаПорядкаЗакрытияПодразделений.Ссылка,
	               |	УстановкаПорядкаЗакрытияПодразделений.Номер,
	               |	УстановкаПорядкаЗакрытияПодразделений.Дата КАК Период,
	               |	УстановкаПорядкаЗакрытияПодразделений.Организация
	               |ИЗ
	               |	Документ.УстановкаПорядкаЗакрытияПодразделений КАК УстановкаПорядкаЗакрытияПодразделений
	               |ГДЕ
	               |	УстановкаПорядкаЗакрытияПодразделений.Ссылка = &Ссылка";
				   
	РезультатыЗапроса = Запрос.ВыполнитьПакет();

	ПараметрыПроведения.Вставить("ТаблицаПодразделенийСПорядкомЗакрытия", РезультатыЗапроса[1].Выгрузить());
	ПараметрыПроведения.Вставить("ПараметрыДокумента", РезультатыЗапроса[2].Выгрузить());

	Возврат ПараметрыПроведения;

КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ФОРМИРОВАНИЯ ДВИЖЕНИЙ
//

Процедура СформироватьДвижения(ПараметрыОбъекта, ТаблицаПодразделений, Движения, Отказ) Экспорт

	Объект = ПараметрыОбъекта[0];
	ПорядокЗакрытияПодразделений = Движения.ПорядокЗакрытияПодразделенийОрганизаций;

	Для Каждого Строка Из ТаблицаПодразделений Цикл
		НоваяСтрока = ПорядокЗакрытияПодразделений.Добавить();
		НоваяСтрока.Период        = НачалоМесяца(Объект.Период);
		НоваяСтрока.Подразделение = Строка.Подразделение;
		НоваяСтрока.НомерПередела = Строка.НомерПередела;
		НоваяСтрока.Организация   = Объект.Организация;
	КонецЦикла;

	ПорядокЗакрытияПодразделений.Записывать = Истина;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПЕЧАТИ

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
КонецПроцедуры

#КонецЕсли