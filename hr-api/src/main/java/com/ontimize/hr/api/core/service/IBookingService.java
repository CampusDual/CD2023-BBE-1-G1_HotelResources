package com.ontimize.hr.api.core.service;

import com.ontimize.hr.api.core.service.exception.*;
import com.ontimize.jee.common.dto.EntityResult;

import java.util.List;
import java.util.Map;

public interface IBookingService {

    EntityResult bookingQuery(Map<?, ?> keymap, List<?> attrList);

    EntityResult bookingInsert(Map<?, ?> attrMap) throws InvalidBookingDateException, InvalidIdDocumentException;

    EntityResult bookingDelete(Map<?, ?> keyMap);

    EntityResult bookingUpdate(Map<?, ?> attrMap, Map<?, ?> keyMap) throws InvalidBookingDateException, InvalidIdDocumentException, BookingDoesNotExistException, BookingNotModifiableException, RoomDoesNotExistException, InvalidBookingRoomException;

    String DATE_BEFORE_NOW_MESSAGE = "The arrival date must be after now";
    String ARRIVAL_DATE_AFTER_DEPARTURE_DATE_MESSAGE = "The departure date must be after arrival date";
    String DATES_OVERLAP = "Occupied room in those dates";
    String BOOKING_INSERT_SUCCESS = "Booking inserted successfully";
    String BOOKING_UPDATE_SUCCESS = "Booking updated successfully";
    String BOOKING_NOT_FOUND = "A booking with this ID could not be found";
    String ONE_DAY_MARGIN_ERROR = "Bookings cannot be modified less than 24 prior to the arrival date";
    String NO_BOOKING_WITH_ID = "No booking with this id";
    String DELETION_SUCCESS = "Booking deleted successfully";
    String INVALID_ID_DOCUMENT = "The id document is not valid";
    String USER_NOT_FOUND = "No user with this id could be found";

}
