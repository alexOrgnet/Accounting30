﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "СПАРКРиски".
// ОбщийМодуль.СПАРКРискиКлиентСерверПереопределяемый.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет свойства контрагента в форме или подписках на события.
//
// Параметры:
//	КонтрагентОбъект - ДанныеФормыСтруктура, СправочникОбъект - данные контрагента;
//	Форма - ФормаКлиентскогоПриложения - форма, из которой вызывается обработчик.
//		Если вызывается вне формы, тогда значение Неопределено;
//	СвойстваКонтрагента - Структура - в параметре возвращаются свойства контрагента:
//		* ИНН - Строка - ИНН контрагента. Значение по умолчанию - пустая строка;
//		* ПодлежитПроверке - Булево - в параметре необходимо возвратить Истина, если контрагент
//			подлежит проверке в сервисе 1СПАРК Риски, Ложь - в противном случае.
//			Важно. Сервис 1СПАРК Риски не предоставляет информацию иностранным организациям;
//			Значение по умолчанию - Ложь;
//		* СвояОрганизация - Булево - признак того, что контрагент является собственным.
//			Значение по умолчанию - Ложь.
//			Свойство может быть использовано для отбора данных в отчетах;
//		* ВидКонтрагента - ПеречислениеСсылка.ВидыКонтрагентовСПАРКРиски - определяет способ получения данных
//			о контрагенте.
//
//@skip-warning
Процедура ПриОпределенииСвойствКонтрагентаВОбъекте(КонтрагентОбъект, Форма, СвойстваКонтрагента) Экспорт
	
	СвойстваКонтрагента.ИНН = КонтрагентОбъект.ИНН;
	СвойстваКонтрагента.ВидКонтрагента = СПАРКРискиКлиентСерверБП.ВидКонтрагентаСПАРКРиски(КонтрагентОбъект.ЮридическоеФизическоеЛицо);
	СвойстваКонтрагента.СвояОрганизация = Ложь;
	СвойстваКонтрагента.ПодлежитПроверке = Не КонтрагентОбъект.ЭтоГруппа
		И НЕ КонтрагентОбъект.ОбособленноеПодразделение
		И Не КонтрагентОбъект.ГосударственныйОрган;
	
КонецПроцедуры

#Область ИндексыСПАРККонтрагента

// Выводит информацию об индексах СПАРК Риски в элемент управления.
// В случае, если информации нет в кэше, то инициируется фоновое задание.
// Если передан ИНН, то информация получается напрямую из веб-сервиса без фонового задания.
//
// Параметры:
//  РезультатИндексыКонтрагента - Структура - ключи описаны в СПАРКРискиКлиентСервер.НовыйДанныеИндексов();
//  КонтрагентОбъект            - Объект, Неопределено - заполняется в том случае, если форма - это форма
//                                элемента справочника, а не форма документа.
//  Контрагент                  - ОпределяемыйТип.КонтрагентБИП, Строка - Контрагент или ИНН контрагента;
//  Форма                       - ФормаКлиентскогоПриложения - форма, в которой необходимо вывести
//                                информацию об индексах СПАРК Риски.
//  ИспользованиеРазрешено      - Булево - признак разрешения использования функциональности;
//  Параметры                   - Структура - прочие параметры;
//  СтандартнаяОбработка        - Булево - если вернуть сюда Ложь, то стандартная обработка не будет происходить.
//
//@skip-warning
Процедура ОтобразитьИндексыСПАРК(
			РезультатИндексыКонтрагента,
			КонтрагентОбъект,
			Контрагент,
			Форма,
			ИспользованиеРазрешено,
			Параметры,
			СтандартнаяОбработка) Экспорт

	СтандартнаяОбработка = Истина;
	Если Форма.ИмяФормы = "Справочник.Контрагенты.Форма.ФормаЭлемента" Тогда
		
		// На форме должно быть несколько элементов управления:
		// - ДекорацияИндексыСПАРКРискиСтрока1Заголовок;
		// - ДекорацияИндексыСПАРКРискиСтрока1Значение;
		// - ДекорацияИндексыСПАРКРискиСтрока2Заголовок;
		// - ДекорацияИндексыСПАРКРискиСтрока2Значение;
		// - ДекорацияИндексыСПАРКРискиСтрока3Заголовок;
		// - ДекорацияИндексыСПАРКРискиСтрока3Значение;
		// - ДекорацияИндексыСПАРКРискиСтрока4Заголовок;
		// - ДекорацияИндексыСПАРКРискиСтрока4Значение;
		// - КартинкаОжиданиеЗагрузкиИндексовСПАРКРиски.

		СтандартнаяОбработка = Ложь;
		Элементы = Форма.Элементы;
		Если Не ИспользованиеРазрешено Тогда
			Элементы.ГруппаИндексыСПАРКРиски.Видимость = Ложь;
			Возврат;
		КонецЕсли;
		
		Если РезультатИндексыКонтрагента.ПодлежитПроверке Тогда

			Элементы.ГруппаИндексыСПАРКРиски.Видимость = Ложь; // Чтобы изображение не моргало, скроем всю панель. Потом - покажем.

			Элементы.ДекорацияИндексыСПАРКРискиСтрока1Заголовок.Заголовок = Новый ФорматированнаяСтрока(
				НСтр("ru='1СПАРК Риски'"),
				Новый Шрифт(Элементы.ДекорацияИндексыСПАРКРискиСтрока1Заголовок.Шрифт, , , Истина)); // Жирный шрифт;
			Элементы.ДекорацияИндексыСПАРКРискиСтрока1Заголовок.Видимость = Истина;
			Элементы.ДекорацияИндексыСПАРКРискиСтрока1Значение.Видимость  = Ложь;
			Элементы.КартинкаОжиданиеЗагрузкиИндексовСПАРКРиски.Видимость = Ложь;

			ЦветаСтилей = СПАРКРискиВызовСервера.ЦветаСтилей();
			Если Не РезультатИндексыКонтрагента.Критичное Тогда
				ЦветСтатуса = ЦветаСтилей.ЦветГрадацияСПАРКНизкийРиск;
			Иначе
				ЦветСтатуса = ЦветаСтилей.ЦветОсобогоТекста;
			КонецЕсли;

			ЕстьОшибкаПодключения = Истина;

			ВидОшибки               = РезультатИндексыКонтрагента.ВидОшибки;
			СостояниеВыводаДанных   = РезультатИндексыКонтрагента.СостояниеВыводаДанных;
			СостояниеЗагрузкиДанных = РезультатИндексыКонтрагента.СостояниеЗагрузкиДанных;

			Если (ВидОшибки = ПредопределенноеЗначение("Перечисление.ВидыОшибокСПАРКРиски.ВнутренняяОшибкаСервиса"))
					ИЛИ (ВидОшибки = ПредопределенноеЗначение("Перечисление.ВидыОшибокСПАРКРиски.ИнтернетПоддержкаНеПодключена"))
					ИЛИ (ВидОшибки = ПредопределенноеЗначение("Перечисление.ВидыОшибокСПАРКРиски.ИспользованиеЗапрещено"))
					ИЛИ (ВидОшибки = ПредопределенноеЗначение("Перечисление.ВидыОшибокСПАРКРиски.НеизвестнаяОшибка"))
					ИЛИ (ВидОшибки = ПредопределенноеЗначение("Перечисление.ВидыОшибокСПАРКРиски.НекорректныйЗапрос"))
					ИЛИ (ВидОшибки = ПредопределенноеЗначение("Перечисление.ВидыОшибокСПАРКРиски.НеПодлежитПроверке"))
					ИЛИ (ВидОшибки = ПредопределенноеЗначение("Перечисление.ВидыОшибокСПАРКРиски.ОшибкаПодключения"))
					ИЛИ (ВидОшибки = ПредопределенноеЗначение("Перечисление.ВидыОшибокСПАРКРиски.ПревышеноКоличествоПопытокАутентификации"))
					ИЛИ (ВидОшибки = ПредопределенноеЗначение("Перечисление.ВидыОшибокСПАРКРиски.ТребуетсяОплатаИлиПревышенЛимит")) Тогда
				// Эти виды ошибок никак не отображаются на форме.
			ИначеЕсли ВидОшибки = ПредопределенноеЗначение("Перечисление.ВидыОшибокСПАРКРиски.НеизвестныйИНН") Тогда
				
				ЕстьОшибкаПодключения = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока2Заголовок.Заголовок = Новый ФорматированнаяСтрока(
					НСтр("ru='Нет информации о контрагенте'"),
					,
					,
					,
					"SPARK:NoInformation");
					
				Элементы.ДекорацияИндексыСПАРКРискиСтрока2Заголовок.Видимость = Истина;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока2Значение.Видимость  = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока3Заголовок.Видимость = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока3Значение.Видимость  = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока4Заголовок.Видимость = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока4Значение.Видимость  = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока5Заголовок.Видимость = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока5Значение.Видимость  = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока6Заголовок.Видимость = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока6Значение.Видимость  = Ложь;
				Элементы.КартинкаОжиданиеЗагрузкиИндексовСПАРКРиски.Видимость = Ложь;
				
			ИначеЕсли ВидОшибки = ПредопределенноеЗначение("Перечисление.ВидыОшибокСПАРКРиски.НекорректныйИНН") Тогда
				// Оба состояния должны обрабатываться одинаково (вывести сообщение об ошибке):
				// - пустой ИНН;
				// - некорректный ИНН.
				ЕстьОшибкаПодключения = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока2Заголовок.Заголовок =
					Новый ФорматированнаяСтрока(НСтр("ru='Нет информации о контрагенте'"),
					,
					ЦветаСтилей.ЦветОсобогоТекста,
					,
					"SPARK:NoInformation");
				Элементы.ДекорацияИндексыСПАРКРискиСтрока2Заголовок.Видимость = Истина;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока2Значение.Видимость  = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока3Заголовок.Видимость = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока3Значение.Видимость  = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока4Заголовок.Видимость = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока4Значение.Видимость  = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока5Заголовок.Видимость = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока5Значение.Видимость  = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока6Заголовок.Видимость = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока6Значение.Видимость  = Ложь;
				Элементы.КартинкаОжиданиеЗагрузкиИндексовСПАРКРиски.Видимость = Ложь;
			Иначе // Пустое поле - ошибок нет.
				ЕстьОшибкаПодключения = Ложь;
				ЕстьОшибкаПолученияДанных = Ложь;

				ТекстОшибки = "";
				ЦветТекстаОшибки = ЦветаСтилей.ЦветОсобогоТекста;
				Если СостояниеВыводаДанных = ПредопределенноеЗначение("Перечисление.СостоянияВыводаИндексовСПАРКРиски.ВКэшеНетДанных") Тогда
					ЕстьОшибкаПолученияДанных = Истина;
					Если СостояниеЗагрузкиДанных = ПредопределенноеЗначение("Перечисление.СостоянияЗагрузкиИндексовСПАРКРиски.ЗапущеноФоновоеЗадание") Тогда
						ТекстОшибки = НСтр("ru='Получение данных...'");
						ЦветТекстаОшибки = Неопределено; // Авто
					ИначеЕсли СостояниеЗагрузкиДанных = ПредопределенноеЗначение("Перечисление.СостоянияЗагрузкиИндексовСПАРКРиски.ОтменаФоновогоЗадания") Тогда
						ТекстОшибки = НСтр("ru='Ошибка получения данных (слишком медленное соединение или отменено администратором)'");
					ИначеЕсли СостояниеЗагрузкиДанных = ПредопределенноеЗначение("Перечисление.СостоянияЗагрузкиИндексовСПАРКРиски.ОшибкаФоновогоЗадания") Тогда
						ТекстОшибки = НСтр("ru='Ошибка получения данных'");
					Иначе // Загрузка завершена или не осуществлялась.
						ТекстОшибки = НСтр("ru='Ошибка получения данных (данные не получены)'");
					КонецЕсли;
				ИначеЕсли СостояниеВыводаДанных = ПредопределенноеЗначение("Перечисление.СостоянияВыводаИндексовСПАРКРиски.ВКэшеУстаревшиеДанные") Тогда
				ИначеЕсли СостояниеВыводаДанных = ПредопределенноеЗначение("Перечисление.СостоянияВыводаИндексовСПАРКРиски.НеправильныйИНН") Тогда
					ЕстьОшибкаПолученияДанных = Истина;
					ТекстОшибки = Новый ФорматированнаяСтрока(
						НСтр("ru='Нет информации о контрагенте'"),
						,
						,
						,
						"SPARK:NoInformation");
				ИначеЕсли СостояниеВыводаДанных = ПредопределенноеЗначение("Перечисление.СостоянияВыводаИндексовСПАРКРиски.ПолученоИзКэша") Тогда
				ИначеЕсли СостояниеВыводаДанных = ПредопределенноеЗначение("Перечисление.СостоянияВыводаИндексовСПАРКРиски.ПолученоИзФоновогоЗадания") Тогда
				ИначеЕсли СостояниеВыводаДанных = ПредопределенноеЗначение("Перечисление.СостоянияВыводаИндексовСПАРКРиски.ПустаяСсылка") Тогда
				Иначе
					ЕстьОшибкаПолученияДанных = Истина;
					ТекстОшибки = НСтр("ru='Неопределенная ошибка'");
				КонецЕсли;

				Если СостояниеЗагрузкиДанных = ПредопределенноеЗначение("Перечисление.СостоянияЗагрузкиИндексовСПАРКРиски.ЗапущеноФоновоеЗадание") Тогда
					Элементы.КартинкаОжиданиеЗагрузкиИндексовСПАРКРиски.Видимость = Истина;
				Иначе
					Элементы.КартинкаОжиданиеЗагрузкиИндексовСПАРКРиски.Видимость = Ложь;
				КонецЕсли;

				Если ЕстьОшибкаПолученияДанных = Истина Тогда
					Элементы.ДекорацияИндексыСПАРКРискиСтрока2Заголовок.Заголовок =
						Новый ФорматированнаяСтрока(ТекстОшибки, , ЦветТекстаОшибки);
					Элементы.ДекорацияИндексыСПАРКРискиСтрока2Заголовок.Видимость = Истина;
					Элементы.ДекорацияИндексыСПАРКРискиСтрока2Значение.Видимость  = Ложь;
					Элементы.ДекорацияИндексыСПАРКРискиСтрока3Заголовок.Видимость = Ложь;
					Элементы.ДекорацияИндексыСПАРКРискиСтрока3Значение.Видимость  = Ложь;
					Элементы.ДекорацияИндексыСПАРКРискиСтрока4Заголовок.Видимость = Ложь;
					Элементы.ДекорацияИндексыСПАРКРискиСтрока4Значение.Видимость  = Ложь;
					Элементы.ДекорацияИндексыСПАРКРискиСтрока5Заголовок.Видимость = Ложь;
					Элементы.ДекорацияИндексыСПАРКРискиСтрока5Значение.Видимость  = Ложь;
					Элементы.ДекорацияИндексыСПАРКРискиСтрока6Заголовок.Видимость = Ложь;
					Элементы.ДекорацияИндексыСПАРКРискиСтрока6Значение.Видимость  = Ложь;
				Иначе
					
					// Если контрагент не активен, вывести сообщение "Контрагент прекратил деятельность %ДатаСтатуса%".
					Если (РезультатИндексыКонтрагента.Активен <> Истина) Тогда
						Элементы.ДекорацияИндексыСПАРКРискиСтрока2Заголовок.Заголовок = Новый ФорматированнаяСтрока(
								СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									НСтр("ru='Контрагент прекратил деятельность %1'"),
									Формат(РезультатИндексыКонтрагента.ДатаСтатуса, "ДЛФ=D")),
								,
								ЦветаСтилей.ЦветОсобогоТекста);
						Элементы.ДекорацияИндексыСПАРКРискиСтрока2Значение.Видимость  = Ложь;
						Элементы.ДекорацияИндексыСПАРКРискиСтрока3Заголовок.Видимость = Ложь;
						Элементы.ДекорацияИндексыСПАРКРискиСтрока3Значение.Видимость  = Ложь;
						Элементы.ДекорацияИндексыСПАРКРискиСтрока4Заголовок.Видимость = Ложь;
						Элементы.ДекорацияИндексыСПАРКРискиСтрока4Значение.Видимость  = Ложь;
						Элементы.ДекорацияИндексыСПАРКРискиСтрока5Заголовок.Видимость = Ложь;
						Элементы.ДекорацияИндексыСПАРКРискиСтрока5Значение.Видимость  = Ложь;
						Элементы.ДекорацияИндексыСПАРКРискиСтрока6Заголовок.Видимость = Ложь;
						Элементы.ДекорацияИндексыСПАРКРискиСтрока6Значение.Видимость  = Ложь;
					Иначе

						Строка2Заполнена = Ложь;
						Строка3Заполнена = Ложь;
						Строка4Заполнена = Ложь;
						Строка5Заполнена = Ложь;
						Строка6Заполнена = Ложь;
						МассивСтрок = Новый Массив;

						ИнформацияВыведена = Ложь;

						// Если есть событие, вывести его. В противном случае - индексы.
						Если РезультатИндексыКонтрагента.ОтображатьСтатус
							И ЗначениеЗаполнено(РезультатИндексыКонтрагента.Статус)Тогда
							Элементы.ДекорацияИндексыСПАРКРискиСтрока2Заголовок.Заголовок = Новый ФорматированнаяСтрока(
								СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									НСтр("ru='%1 %2'"),
									РезультатИндексыКонтрагента.СтатусНазвание,
									Формат(РезультатИндексыКонтрагента.ДатаСтатуса, "ДЛФ=D")),
								,
								ЦветСтатуса,
								,
								"SPARK:OpenStatusDescription");
							Элементы.ДекорацияИндексыСПАРКРискиСтрока2Значение.Видимость = Ложь;
							Строка2Заполнена = Истина;
							ИнформацияВыведена = Истина;
						КонецЕсли;
						
						Если (РезультатИндексыКонтрагента.СводныйИндикатор >= 1)
								И (РезультатИндексыКонтрагента.СводныйИндикатор <= 3) Тогда
							ФорматированнаяСтрокаЗаголовок = Новый ФорматированнаяСтрока(
								НСтр("ru='Сводный индикатор:'"));
							ФорматированнаяСтрокаЗначение = Новый ФорматированнаяСтрока(
								Строка(РезультатИндексыКонтрагента.СводныйИндикаторГрадация),
								, // Шрифт
								СПАРКРискиКлиентСервер.ЦветИндекса(
									РезультатИндексыКонтрагента.СводныйИндикатор,
									"СводныйИндикатор"),
								, // ЦветФона
								"SPARK:WhatIsCompositeIndex");
							МассивСтрок.Добавить(Новый Структура("Заголовок, Значение",
								ФорматированнаяСтрокаЗаголовок,
								ФорматированнаяСтрокаЗначение));
							ИнформацияВыведена = Истина;
						КонецЕсли;
						
						Если (РезультатИндексыКонтрагента.ИндексДолжнойОсмотрительности >= 0)
								И (РезультатИндексыКонтрагента.ИндексДолжнойОсмотрительности <= 100) Тогда
							ФорматированнаяСтрокаЗаголовок = Новый ФорматированнаяСтрока(
								НСтр("ru='Индекс должной осмотрительности:'"));
							ФорматированнаяСтрокаЗначение = Новый ФорматированнаяСтрока(
								СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									НСтр("ru='%1 (%2)'"),
									РезультатИндексыКонтрагента.ИндексДолжнойОсмотрительности,
									НРег(РезультатИндексыКонтрагента.ИДОГрадация)),
								, // Шрифт
								СПАРКРискиКлиентСервер.ЦветИндекса(
									РезультатИндексыКонтрагента.ИндексДолжнойОсмотрительности,
									"ИндексДолжнойОсмотрительности"),
								, // ЦветФона
								"SPARK:WhatIsIndexOfDueDiligence");
							МассивСтрок.Добавить(Новый Структура("Заголовок, Значение",
								ФорматированнаяСтрокаЗаголовок,
								ФорматированнаяСтрокаЗначение));
							ИнформацияВыведена = Истина;
						КонецЕсли;

						Если (РезультатИндексыКонтрагента.ИндексФинансовогоРиска >= 0)
								И (РезультатИндексыКонтрагента.ИндексФинансовогоРиска <= 100) Тогда
							ФорматированнаяСтрокаЗаголовок = Новый ФорматированнаяСтрока(
								НСтр("ru='Индекс финансового риска:'"));
							ФорматированнаяСтрокаЗначение = Новый ФорматированнаяСтрока(
								СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									НСтр("ru='%1 (%2)'"),
									РезультатИндексыКонтрагента.ИндексФинансовогоРиска,
									НРег(РезультатИндексыКонтрагента.ИФРГрадация)),
								, // Шрифт
								СПАРКРискиКлиентСервер.ЦветИндекса(
									РезультатИндексыКонтрагента.ИндексФинансовогоРиска,
									"ИндексФинансовогоРиска"),
								, // ЦветФона
								"SPARK:WhatIsFailureScore");
							МассивСтрок.Добавить(Новый Структура("Заголовок, Значение",
								ФорматированнаяСтрокаЗаголовок,
								ФорматированнаяСтрокаЗначение));
							ИнформацияВыведена = Истина;
						КонецЕсли;

						Если (РезультатИндексыКонтрагента.ИндексПлатежнойДисциплины >= 0)
								И (РезультатИндексыКонтрагента.ИндексПлатежнойДисциплины <= 100) Тогда
							ФорматированнаяСтрокаЗаголовок = Новый ФорматированнаяСтрока(
								НСтр("ru='Индекс платежной дисциплины:'"));
							ФорматированнаяСтрокаЗначение = Новый ФорматированнаяСтрока(
								СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									НСтр("ru='%1 (%2)'"),
									РезультатИндексыКонтрагента.ИндексПлатежнойДисциплины,
									НРег(РезультатИндексыКонтрагента.ИПДГрадация)),
								, // Шрифт
								СПАРКРискиКлиентСервер.ЦветИндекса(
									РезультатИндексыКонтрагента.ИндексПлатежнойДисциплины,
									"ИндексПлатежнойДисциплины"),
								, // ЦветФона
								"SPARK:WhatIsPaymentIndex");
							МассивСтрок.Добавить(Новый Структура("Заголовок, Значение",
								ФорматированнаяСтрокаЗаголовок,
								ФорматированнаяСтрокаЗначение));
							ИнформацияВыведена = Истина;
						КонецЕсли;
						
						Если РезультатИндексыКонтрагента.БухгалтерскаяОтчетность = 1 Тогда
							ФорматированнаяСтрокаЗаголовок = Новый ФорматированнаяСтрока(
								НСтр("ru='Передана бух. отчетность в СПАРК'"),
								, // Шрифт
								ЦветаСтилей.ЦветГрадацияСПАРКНизкийРиск,
								, // ЦветФона
								"SPARK:WhatIsAccountingStatements");
							МассивСтрок.Добавить(Новый Структура("Заголовок, Значение",
								ФорматированнаяСтрокаЗаголовок,
								Неопределено));
							ИнформацияВыведена = Истина;
						КонецЕсли;
						
						// Вывести первые строки индексов.
						Для Каждого ТекущиеДанные Из МассивСтрок Цикл
							Если Строка2Заполнена = Ложь Тогда
								// Заполнить данными
								Элементы.ДекорацияИндексыСПАРКРискиСтрока2Заголовок.Заголовок = ТекущиеДанные.Заголовок;
								Элементы.ДекорацияИндексыСПАРКРискиСтрока2Значение.Заголовок  = ТекущиеДанные.Значение;
								Элементы.ДекорацияИндексыСПАРКРискиСтрока2Заголовок.Видимость = Истина;
								Элементы.ДекорацияИндексыСПАРКРискиСтрока2Значение.Видимость  = Истина;
								Строка2Заполнена = Истина;
							ИначеЕсли Строка3Заполнена = Ложь Тогда
								// Заполнить данными
								Элементы.ДекорацияИндексыСПАРКРискиСтрока3Заголовок.Заголовок = ТекущиеДанные.Заголовок;
								Элементы.ДекорацияИндексыСПАРКРискиСтрока3Значение.Заголовок  = ТекущиеДанные.Значение;
								Элементы.ДекорацияИндексыСПАРКРискиСтрока3Заголовок.Видимость = Истина;
								Элементы.ДекорацияИндексыСПАРКРискиСтрока3Значение.Видимость  = Истина;
								Строка3Заполнена = Истина;
							ИначеЕсли Строка4Заполнена = Ложь Тогда
								// Заполнить данными
								Элементы.ДекорацияИндексыСПАРКРискиСтрока4Заголовок.Заголовок = ТекущиеДанные.Заголовок;
								Элементы.ДекорацияИндексыСПАРКРискиСтрока4Значение.Заголовок  = ТекущиеДанные.Значение;
								Элементы.ДекорацияИндексыСПАРКРискиСтрока4Заголовок.Видимость = Истина;
								Элементы.ДекорацияИндексыСПАРКРискиСтрока4Значение.Видимость  = Истина;
								Строка4Заполнена = Истина;
							ИначеЕсли Строка5Заполнена = Ложь Тогда
								// Заполнить данными
								Элементы.ДекорацияИндексыСПАРКРискиСтрока5Заголовок.Заголовок = ТекущиеДанные.Заголовок;
								Элементы.ДекорацияИндексыСПАРКРискиСтрока5Значение.Заголовок  = ТекущиеДанные.Значение;
								Элементы.ДекорацияИндексыСПАРКРискиСтрока5Заголовок.Видимость = Истина;
								Элементы.ДекорацияИндексыСПАРКРискиСтрока5Значение.Видимость  = Истина;
								Строка5Заполнена = Истина;
							ИначеЕсли Строка6Заполнена = Ложь Тогда
								// Заполнить данными
								Элементы.ДекорацияИндексыСПАРКРискиСтрока6Заголовок.Заголовок = ТекущиеДанные.Заголовок;
								Элементы.ДекорацияИндексыСПАРКРискиСтрока6Значение.Заголовок  = ТекущиеДанные.Значение;
								Элементы.ДекорацияИндексыСПАРКРискиСтрока6Заголовок.Видимость = Истина;
								Элементы.ДекорацияИндексыСПАРКРискиСтрока6Значение.Видимость  = Истина;
								Строка6Заполнена = Истина;
							КонецЕсли;
						КонецЦикла;

						Если Строка2Заполнена = Ложь Тогда
							Элементы.ДекорацияИндексыСПАРКРискиСтрока2Заголовок.Видимость = Ложь;
							Элементы.ДекорацияИндексыСПАРКРискиСтрока2Значение.Видимость  = Ложь;
						КонецЕсли;
						Если Строка3Заполнена = Ложь Тогда
							Элементы.ДекорацияИндексыСПАРКРискиСтрока3Заголовок.Видимость = Ложь;
							Элементы.ДекорацияИндексыСПАРКРискиСтрока3Значение.Видимость  = Ложь;
						КонецЕсли;
						Если Строка4Заполнена = Ложь Тогда
							Элементы.ДекорацияИндексыСПАРКРискиСтрока4Заголовок.Видимость = Ложь;
							Элементы.ДекорацияИндексыСПАРКРискиСтрока4Значение.Видимость  = Ложь;
						КонецЕсли;
						Если Строка5Заполнена = Ложь Тогда
							Элементы.ДекорацияИндексыСПАРКРискиСтрока5Заголовок.Видимость = Ложь;
							Элементы.ДекорацияИндексыСПАРКРискиСтрока5Значение.Видимость  = Ложь;
						КонецЕсли;
						Если Строка6Заполнена = Ложь Тогда
							Элементы.ДекорацияИндексыСПАРКРискиСтрока6Заголовок.Видимость = Ложь;
							Элементы.ДекорацияИндексыСПАРКРискиСтрока6Значение.Видимость  = Ложь;
						КонецЕсли;

						
						Если ИнформацияВыведена <> Истина Тогда // Ничего не выведено - вывести "Нет информации о контрагенте".
							
							Элементы.ДекорацияИндексыСПАРКРискиСтрока2Заголовок.Заголовок = Новый ФорматированнаяСтрока(
								НСтр("ru='Нет информации о контрагенте'"),
								,
								,
								,
								"SPARK:NoInformation");
							
							Элементы.ДекорацияИндексыСПАРКРискиСтрока2Заголовок.Видимость = Истина;
							Элементы.ДекорацияИндексыСПАРКРискиСтрока2Значение.Видимость  = Ложь;
							Элементы.ДекорацияИндексыСПАРКРискиСтрока3Заголовок.Видимость = Ложь;
							Элементы.ДекорацияИндексыСПАРКРискиСтрока3Значение.Видимость  = Ложь;
							Элементы.ДекорацияИндексыСПАРКРискиСтрока4Заголовок.Видимость = Ложь;
							Элементы.ДекорацияИндексыСПАРКРискиСтрока4Значение.Видимость  = Ложь;
							Элементы.ДекорацияИндексыСПАРКРискиСтрока5Заголовок.Видимость = Ложь;
							Элементы.ДекорацияИндексыСПАРКРискиСтрока5Значение.Видимость  = Ложь;
							Элементы.ДекорацияИндексыСПАРКРискиСтрока6Заголовок.Видимость = Ложь;
							Элементы.ДекорацияИндексыСПАРКРискиСтрока6Значение.Видимость  = Ложь;
							Элементы.КартинкаОжиданиеЗагрузкиИндексовСПАРКРиски.Видимость = Ложь;
						КонецЕсли;

					КонецЕсли;

				КонецЕсли;
			КонецЕсли;

			Если ЕстьОшибкаПодключения = Истина Тогда

				Элементы.КартинкаОжиданиеЗагрузкиИндексовСПАРКРиски.Видимость = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока1Заголовок.Заголовок = НСтр("ru='1СПАРК Риски'");
				Элементы.ДекорацияИндексыСПАРКРискиСтрока1Заголовок.Шрифт = Новый Шрифт(Элементы.ДекорацияИндексыСПАРКРискиСтрока1Заголовок.Шрифт, , , Истина);
				Элементы.ДекорацияИндексыСПАРКРискиСтрока1Значение.Видимость = Ложь;
				
				Если ВидОшибки = ПредопределенноеЗначение("Перечисление.ВидыОшибокСПАРКРиски.ТребуетсяОплатаИлиПревышенЛимит")
					И РезультатИндексыКонтрагента.ДоступностьПодключенияТестовогоПериода = "Доступно" Тогда
					
					МассивСтрок = Новый Массив;
					МассивСтрок.Добавить(
						Новый ФорматированнаяСтрока(
							НСтр("ru='Подключить'"),
							,
							,
							,
							"SPARK:ConnectTrialTariff"));
					МассивСтрок.Добавить(" ");
					МассивСтрок.Добавить(НСтр("ru = 'тестовый период'"));
					МассивСтрок.Добавить(Символы.ПС);
					МассивСтрок.Добавить(НСтр("ru = 'или'"));
					МассивСтрок.Добавить(" ");
					МассивСтрок.Добавить(
						Новый ФорматированнаяСтрока(
						НСтр("ru='купить сервис'"),
						,
						,
						,
						"SPARK:BuyService"));
					МассивСтрок.Добавить(" ");
					МассивСтрок.Добавить(НСтр("ru = 'проверки'"));
					МассивСтрок.Добавить(Символы.ПС);
					МассивСтрок.Добавить(НСтр("ru = 'и мониторинга контрагентов'"));
					
					Элементы.ДекорацияИндексыСПАРКРискиСтрока2Заголовок.Заголовок =
						 Новый ФорматированнаяСтрока(МассивСтрок);
					Элементы.ДекорацияИндексыСПАРКРискиСтрока2Значение.Видимость = Ложь;
					
				ИначеЕсли ВидОшибки = ПредопределенноеЗначение("Перечисление.ВидыОшибокСПАРКРиски.ТребуетсяОплатаИлиПревышенЛимит")
						И РезультатИндексыКонтрагента.ДоступностьПодключенияТестовогоПериода = "Подключение" Тогда
					Элементы.ДекорацияИндексыСПАРКРискиСтрока3Заголовок.Заголовок =
						НСтр("ru = 'Выполняется подключение.'");
				Иначе
					
					МассивСтрок = Новый Массив;
					Если Не РезультатИндексыКонтрагента.ДанныеАутентификацииЗаполнены
						Или РезультатИндексыКонтрагента.РаботаВМоделиСервиса Тогда
						МассивСтрок.Добавить(
							Новый ФорматированнаяСтрока(
							НСтр("ru='Подробнее о сервисе'"),
							,
							,
							,
							"SPARK:About"));
						МассивСтрок.Добавить(" ");
						МассивСтрок.Добавить(НСтр("ru = 'проверки'"));
						МассивСтрок.Добавить(Символы.ПС);
						МассивСтрок.Добавить(НСтр("ru = 'и мониторинга контрагентов'"));
					Иначе
						МассивСтрок.Добавить(
							Новый ФорматированнаяСтрока(
							НСтр("ru='Купить сервис'"),
							,
							,
							,
							"SPARK:BuyService"));
						МассивСтрок.Добавить(" ");
						МассивСтрок.Добавить(НСтр("ru = 'проверки и'"));
						МассивСтрок.Добавить(Символы.ПС);
						МассивСтрок.Добавить(НСтр("ru = 'мониторинга контрагентов'"));
					КонецЕсли;
					
					
					Элементы.ДекорацияИндексыСПАРКРискиСтрока2Заголовок.Заголовок =
						Новый ФорматированнаяСтрока(МассивСтрок);
				КонецЕсли;
				
				Элементы.ДекорацияИндексыСПАРКРискиСтрока2Заголовок.Видимость = Истина;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока2Значение.Видимость  = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока3Заголовок.Видимость = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока3Значение.Видимость  = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока4Заголовок.Видимость = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока4Значение.Видимость  = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока5Заголовок.Видимость = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока5Значение.Видимость  = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока6Заголовок.Видимость = Ложь;
				Элементы.ДекорацияИндексыСПАРКРискиСтрока6Значение.Видимость  = Ложь;
				
			КонецЕсли;

			Элементы.ГруппаИндексыСПАРКРиски.Видимость = Истина; // Чтобы изображение не моргало, вся панель была скрыта. Снова отобразить.

		Иначе

			Элементы.ГруппаИндексыСПАРКРиски.Видимость = Ложь;

		КонецЕсли;
	
	ИначеЕсли Форма.ИмяФормы = "Документ.ПлатежноеПоручение.Форма.ФормаДокумента" Тогда
		
		// Управление видимостью гиперссылки для открытия формы
		// с подробным отображением индексов.
		Если ИспользованиеРазрешено Тогда
			
			ВидимостьЭлементов = РезультатИндексыКонтрагента.Активен
				И Не ЗначениеЗаполнено(РезультатИндексыКонтрагента.ИдентификаторФоновогоЗадания)
				И (РезультатИндексыКонтрагента.ИндексДолжнойОсмотрительности >= 0
				Или РезультатИндексыКонтрагента.ИндексПлатежнойДисциплины >= 0
				Или РезультатИндексыКонтрагента.ИндексФинансовогоРиска >= 0
				Или РезультатИндексыКонтрагента.СводныйИндикатор > 0);
			
			Форма.Элементы.КартинкаОжиданиеЗагрузкиИндексовСПАРКРиски.Видимость = ВидимостьЭлементов;
			Если Не ЗначениеЗаполнено(Форма.Объект.Контрагент) Тогда
				СтандартнаяОбработка                                = Ложь;
				Форма.Элементы.ДекорацияИндексыСПАРКРиски.Заголовок = "";
			КонецЕсли;
			Форма.Элементы.ГруппаИндексыСПАРКРиски.Видимость = Истина;
			
			СПАРКРискиКлиентСерверБП.ОбработатьОшибкуПодключения(Форма, РезультатИндексыКонтрагента, СтандартнаяОбработка)
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает информацию об индексах СПАРК Риски в виде структуры форматированных строк.
// В случае, если информации нет в кэше, то инициируется фоновое задание.
// Если передан ИНН, то информация получается напрямую из веб-сервиса без фонового задания.
//
// Параметры:
//  ПредставленияИндексов - Структура - сюда необходимо передать форматированные строки,
//                          если необходимо переопределение;
//  РезультатИндексыКонтрагента - Структура, Неопределено - результата выполнения функции ИндексыСПАРККонтрагента
//                                (ключи описаны в СПАРКРискиКлиентСервер.НовыйДанныеИндексов()),
//                                или Неопределено, если необходимо вызвать эту функцию;
//  Контрагент - ОпределяемыйТип.КонтрагентБИП, Строка - Контрагент или ИНН контрагента;
//  Форма      - ФормаКлиентскогоПриложения - форма, в которой необходимо вывести информацию об индексах СПАРК Риски;
//  СтандартнаяОбработка - Булево - если вернуть сюда Ложь, то стандартная обработка не будет происходить.
//
//@skip-warning
Процедура ПолучитьПредставленияИндексов(
			ПредставленияИндексов,
			РезультатИндексыКонтрагента,
			Контрагент,
			Форма,
			СтандартнаяОбработка) Экспорт

КонецПроцедуры

#КонецОбласти

#КонецОбласти
