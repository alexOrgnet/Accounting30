﻿#Область СлужебныеПроцедурыИФункции

// Процедура предназначена для выполнения действия, сопряженных с регистрацией отработанного времени.
//
Процедура ПриРегистрацииОтработанногоВремени(Движения, ЗаписыватьДвижения = Ложь) Экспорт
	
КонецПроцедуры

Процедура ПриЗаполненииСтрокРегистрацииНачисленнойЗарплаты(ТаблицаНачислений, СтрокиНачислений) Экспорт

КонецПроцедуры

Функция ПравилаУчетаНачисленийСотрудников() Экспорт

	Возврат УчетНачисленнойЗарплатыБазовый.ПравилаУчетаНачисленийСотрудников();

КонецФункции 

Процедура СкорректироватьДатыНачисленийБезПериодаДействия(ТаблицаНачислений, ПериодРегистрации, ИмяПоляНачисления = "НачислениеУдержание") Экспорт
	
КонецПроцедуры

Функция ЗапросВТНачисленныеДоходы(ИмяВТНачисленныеДоходы) Экспорт
	Возврат УчетНачисленнойЗарплатыБазовый.ЗапросВТНачисленныеДоходы(ИмяВТНачисленныеДоходы);
КонецФункции

Функция ВидыДоходовИсполнительногоПроизводстваНачислений(Период) Экспорт
	Возврат УчетНачисленнойЗарплатыБазовый.ВидыДоходовИсполнительногоПроизводстваНачислений(Период);
КонецФункции

#Область ПроцедурыИФункцииРаботыСОтчетами

// Формирование отчета Анализ начислений и удержаний.
//
Процедура ПриКомпоновкеОтчетаАнализНачисленийИУдержаний(Отчет, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка, НаАванс = Ложь) Экспорт
	УчетНачисленнойЗарплатыБазовый.ПриКомпоновкеОтчетаАнализНачисленийИУдержаний(Отчет, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка, НаАванс)
КонецПроцедуры

Процедура ДобавитьПользовательскиеПоляДополнительныхНачисленийИУдержаний(ДополнительныеНачисленияИУдержания, НастройкиОтчета, КоличествоНачисленийУдержаний, ВидПолей, НаАванс) Экспорт
	
КонецПроцедуры

// Возвращает начисления в том порядке, в котором они должны быть выведены в отчете.
//
Функция ПорядокДополнительныхНачислений(Начисления, ДанныеОтчета, СоответствиеПользовательскихПолей, НачальныйНомерКолонки) Экспорт
	Возврат УчетНачисленнойЗарплатыБазовый.ПорядокДополнительныхНачислений(Начисления, ДанныеОтчета, СоответствиеПользовательскихПолей, НачальныйНомерКолонки);
КонецФункции

// Возвращает удержания в том порядке, в котором они должны быть выведены в отчете.
//
Функция ПорядокДополнительныхУдержаний(Удержания, ДанныеОтчета, СоответствиеПользовательскихПолей, НачальныйНомерКолонки) Экспорт
	Возврат УчетНачисленнойЗарплатыБазовый.ПорядокДополнительныхУдержаний(Удержания, ДанныеОтчета, СоответствиеПользовательскихПолей, НачальныйНомерКолонки);
КонецФункции

Функция ДополнительныеНачисленияОтчетаАнализНачисленийИУдержанийТ49() Экспорт
	Возврат УчетНачисленнойЗарплатыБазовый.ДополнительныеНачисленияОтчетаАнализНачисленийИУдержанийТ49();
КонецФункции

Функция ДополнительныеУдержанияОтчетаАнализНачисленийИУдержанийТ49() Экспорт
	Возврат УчетНачисленнойЗарплатыБазовый.ДополнительныеУдержанияОтчетаАнализНачисленийИУдержанийТ49();
КонецФункции

Процедура ЗаполнитьДополнительныеПоляОтчетаАнализНачисленийИУдержаний(ОтчетОбъект, ДополнительныеПоля) Экспорт
	
	УчетНачисленнойЗарплатыБазовый.ЗаполнитьДополнительныеПоляОтчетаАнализНачисленийИУдержаний(ОтчетОбъект, ДополнительныеПоля);
	
КонецПроцедуры

Функция ПустоеЗначениеТерриторияНаЯзыкеЗапросов() Экспорт

	Возврат УчетНачисленнойЗарплатыБазовый.ПустоеЗначениеТерриторияНаЯзыкеЗапросов();

КонецФункции


#КонецОбласти

#КонецОбласти
