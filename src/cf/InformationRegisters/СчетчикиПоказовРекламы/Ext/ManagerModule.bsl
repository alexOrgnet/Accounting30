﻿// @strict-types

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Увеличить счетчики.
// 
// Измерение "ИдентификаторРекламы" имеет тип ОпределяемыйТип.ИдентификаторРекламы (Строка) 
// потому что справочник Реклама в режиме сервиса не разделенный, 
// и добавление/удаление элементов производится в неразделенном режиме. При этом данный регистр разделенный,
// а удаление записей из не разделенного режима не возможно
// 
// Параметры:
//  ИдентификаторРекламы - ОпределяемыйТип.ИдентификаторРекламы
//
Процедура УвеличитьСчетчики(Знач ИдентификаторРекламы) Экспорт
	
	Профиль = РекламныйСервисСлужебный.ТекущийПрофильПотребителя();
	
	НачатьТранзакцию();
	
	Попытка
		
		УстановитьПривилегированныйРежим(Истина);
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.СчетчикиПоказовРекламы");
		ЭлементБлокировки.УстановитьЗначение("ИдентификаторРекламы", ИдентификаторРекламы);
		ЭлементБлокировки.УстановитьЗначение("ПрофильПотребителя", Профиль);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ИдентификаторРекламы.Установить(ИдентификаторРекламы);
		НаборЗаписей.Отбор.ПрофильПотребителя.Установить(Профиль);
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.Количество() = 0 Тогда
			СтрокаСчетчика = НаборЗаписей.Добавить();
		Иначе
			СтрокаСчетчика = НаборЗаписей[0];
		КонецЕсли;
		
		СтрокаСчетчика.ИдентификаторРекламы = ИдентификаторРекламы;
		СтрокаСчетчика.ПрофильПотребителя = Профиль;
		СтрокаСчетчика.Показы = СтрокаСчетчика.Показы + 1;
		СтрокаСчетчика.ДатаПоследнегоПоказа = ТекущаяДатаСеанса();
		
		НаборЗаписей.Записать();
		
		УстановитьПривилегированныйРежим(Ложь);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ИмяСобытия = РекламныйСервисСлужебный.ИмяСобытияВзаимодействия();
		Комментарий = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(
			ИмяСобытия, 
			УровеньЖурналаРегистрации.Ошибка, , 
			ИдентификаторРекламы, 
			Комментарий);
		
		ВызватьИсключение Комментарий;
	
	КонецПопытки;
	
КонецПроцедуры

// Удалить счетчики не существующей рекламы.
//
Процедура УдалитьСчетчикиУдаленнойРекламы() Экспорт
	
	ДатаНачала = ОценкаПроизводительности.НачатьЗамерВремени();
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВыборкаДетальныеЗаписи = ВыборкаСчетчиковУдаленнойРекламы();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ИдентификаторРекламы.Установить(ВыборкаДетальныеЗаписи.ИдентификаторРекламы);
		НаборЗаписей.Отбор.ПрофильПотребителя.Установить(ВыборкаДетальныеЗаписи.ПрофильПотребителя);
		НаборЗаписей.Записать();
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	ОценкаПроизводительности.ЗакончитьЗамерВремени(
		НСтр("ru = 'РекламныйСервис: УдалитьСчетчикиУдаленнойРекламы'", ОбщегоНазначения.КодОсновногоЯзыка()), 
		ДатаНачала);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выборка счетчиков удаленной рекламы.
// 
// Возвращаемое значение:
//  ВыборкаИзРезультатаЗапроса:
// * ИдентификаторРекламы - ОпределяемыйТип.ИдентификаторРекламы
// * ПрофильПотребителя - ОпределяемыйТип.ПрофильПотребителяРекламы
//
Функция ВыборкаСчетчиковУдаленнойРекламы()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СчетчикиПоказовРекламы.ИдентификаторРекламы,
		|	СчетчикиПоказовРекламы.ПрофильПотребителя,
		|	Реклама.Ссылка
		|ИЗ
		|	РегистрСведений.СчетчикиПоказовРекламы КАК СчетчикиПоказовРекламы
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Реклама КАК Реклама
		|		ПО СчетчикиПоказовРекламы.ИдентификаторРекламы = Реклама.Код
		|ГДЕ
		|	Реклама.Ссылка ЕСТЬ NULL";
	
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Возврат ВыборкаДетальныеЗаписи;
	
КонецФункции

#КонецОбласти

#КонецЕсли