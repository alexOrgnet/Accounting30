﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция возвращает список состояний, при которых не требуется поступление.
//
// Возвращаемое значение:
//	СписокЗначений - список состояний.
//
Функция СписокСостоянийНеТребуетсяПоступление() Экспорт

	СписокСостоянийНеТребуетсяПоступление = Новый СписокЗначений;
	СписокСостоянийНеТребуетсяПоступление.Добавить(Перечисления.СостоянияОтправкиПодтвержденияГИСМ.ОжидаетсяПоступление);
	СписокСостоянийНеТребуетсяПоступление.Добавить(Перечисления.СостоянияОтправкиПодтвержденияГИСМ.ВыбратьПоступление);
	
	Возврат СписокСостоянийНеТребуетсяПоступление
	
КонецФункции

// Функция возвращает список состояний, при которых недоступно изменений поступления.
//
// Возвращаемое значение:
//	СписокЗначений - список состояний.
//
Функция СписокСостоянийНедоступныИзмененияПоступления() Экспорт
	
	СписокСостоянийНедоступныИзменения = Новый СписокЗначений;
	СписокСостоянийНедоступныИзменения.Добавить(Перечисления.СостоянияОтправкиПодтвержденияГИСМ.КПередаче);
	СписокСостоянийНедоступныИзменения.Добавить(Перечисления.СостоянияОтправкиПодтвержденияГИСМ.Передано);
	СписокСостоянийНедоступныИзменения.Добавить(Перечисления.СостоянияОтправкиПодтвержденияГИСМ.ПринятоГИСМ);
	
	Возврат СписокСостоянийНедоступныИзменения;

КонецФункции 

#КонецОбласти

#КонецЕсли