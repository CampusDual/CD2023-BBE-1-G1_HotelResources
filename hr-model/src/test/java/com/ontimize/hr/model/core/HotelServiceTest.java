package com.ontimize.hr.model.core;

import com.ontimize.hr.api.core.service.IHotelService;
import com.ontimize.hr.model.core.dao.HotelDAO;
import com.ontimize.hr.model.core.dao.RoomDAO;
import com.ontimize.hr.model.core.service.HotelService;
import com.ontimize.hr.model.core.service.RoomService;
import com.ontimize.hr.model.core.util.RoomUtils;
import com.ontimize.jee.common.dto.EntityResult;
import com.ontimize.jee.common.dto.EntityResultMapImpl;
import com.ontimize.jee.server.dao.DefaultOntimizeDaoHelper;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestInstance;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class HotelServiceTest {
    @InjectMocks
    HotelService hotelService;
    @Mock
    DefaultOntimizeDaoHelper daoHelper;
    @Mock
    RoomService roomService;

    @Mock
    RoomUtils roomUtils;

    @Nested
    @TestInstance(TestInstance.Lifecycle.PER_CLASS)
    class InsertHotel {
        Map<Object, Object> attrMap = new HashMap<>();

        @Test
        void insertHotel_validHotel_hotelIsSaved_Test() {
            attrMap.put(HotelDAO.NUMBER_OF_FLOORS, 6);
            attrMap.put(HotelDAO.NAME, "Hotel Estrella");

            assertDoesNotThrow(() -> hotelService.hotelInsert(attrMap));
        }

        @Test
        void insertHotel_invalidHotel_numberOfFloorsOverMaximum_Test() {
            attrMap.put(HotelDAO.NUMBER_OF_FLOORS, 110);
            attrMap.put(HotelDAO.NAME, "Hotel Estrella");

            EntityResult actualResult = null;

            actualResult = hotelService.hotelInsert(attrMap);


            assertEquals(EntityResult.OPERATION_WRONG, actualResult.getCode());
        }

        @Test
        void insertHotel_invalidHotel_numberOfFloorsUnderMinimum() {
            attrMap.put(HotelDAO.NUMBER_OF_FLOORS, -5);
            attrMap.put(HotelDAO.NAME, "Hotel Estrella");

            EntityResult actualResult = null;

            actualResult = hotelService.hotelInsert(attrMap);


            assertEquals(EntityResult.OPERATION_WRONG, actualResult.getCode());
        }


        @Test
        void insertBooking_invalidBooking_datesOverlap() {
            EntityResult conflictingEntityResult = new EntityResultMapImpl();

            attrMap.put(HotelDAO.NUMBER_OF_FLOORS, 5);
            attrMap.put(HotelDAO.NAME, "Hotel Estrella");

            conflictingEntityResult.put(HotelDAO.NUMBER_OF_FLOORS, List.of(5));
            conflictingEntityResult.put(HotelDAO.NAME, List.of("Hotel Estrella"));

            when(daoHelper.query(any(), any(), any())).thenReturn(conflictingEntityResult);

            EntityResult actualResult = hotelService.hotelInsert(attrMap);

            assertEquals(IHotelService.HOTEL_ALREADY_EXISTS_ERROR, actualResult.getMessage());
            assertEquals(EntityResult.OPERATION_WRONG, actualResult.getCode());
        }

    }

    @Nested
    @TestInstance(TestInstance.Lifecycle.PER_CLASS)
    class deleteHotel {

        Map<Object, Object> keymap = new HashMap<>();

        @Test
        void deleteHotel_validHotel_HotelIsDeleted() {

            keymap.put(HotelDAO.ID, 1);

            EntityResult er = new EntityResultMapImpl();
            er.setCode(EntityResult.OPERATION_SUCCESSFUL_SHOW_MESSAGE);

            when(daoHelper.delete(any(), any())).thenReturn(er);
            when(daoHelper.query(any(), any(), any())).thenReturn(new EntityResultMapImpl());

            assertDoesNotThrow(() -> hotelService.hotelDelete(keymap));
        }

        @Test
        void deleteHotel_HotelIsNotDeleted() {

            keymap.put(HotelDAO.ID, 1);

            EntityResult er = new EntityResultMapImpl();
            er.setCode(EntityResult.OPERATION_WRONG);
            er.setMessage("No hotels with this id");


            when(daoHelper.delete(any(), any())).thenReturn(er);
            when(daoHelper.query(any(), any(), any())).thenReturn(new EntityResultMapImpl());

            EntityResult result = hotelService.hotelDelete(keymap);
            assertEquals(EntityResult.OPERATION_WRONG, result.getCode());
            assertEquals("No hotels with this id", result.getMessage());
        }
    }

    @Nested
    @TestInstance(TestInstance.Lifecycle.PER_CLASS)
    class UpdateHotel {
        Map<Object, Object> attrMap = new HashMap<>();
        Map<Object, Object> keyMap = new HashMap<>();

        @Test
        void updateHotel_validHotel_hotelIsUpdated() {

            attrMap.put(HotelDAO.NUMBER_OF_FLOORS, 6);
            attrMap.put(HotelDAO.NAME, "Hotel Estrella");
            keyMap.put(HotelDAO.ID, 1);

            EntityResult hotelRoomsEntityResult = new EntityResultMapImpl();
            hotelRoomsEntityResult.put(RoomDAO.ROOM_NUMBER, List.of(101));
            when(roomUtils.getFloorNumber(101)).thenReturn(1);
            when(roomService.roomQuery(anyMap(), anyList())).thenReturn(hotelRoomsEntityResult);

            EntityResult hotelToUpdateEntityResult = new EntityResultMapImpl();
            hotelToUpdateEntityResult.put(HotelDAO.ID, List.of(1));
            hotelToUpdateEntityResult.put(HotelDAO.NUMBER_OF_FLOORS, List.of(7));


            when(daoHelper.query(any(), (any()), any())).thenReturn(hotelToUpdateEntityResult);
            EntityResult updateResult = new EntityResultMapImpl();
            updateResult.setCode(EntityResult.OPERATION_SUCCESSFUL_SHOW_MESSAGE);
            updateResult.setMessage("Hotel updated successfully");
            when(daoHelper.update(any(), any(), any())).thenReturn(updateResult);

            EntityResult result;
            try {
                result = hotelService.hotelUpdate(attrMap, keyMap);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }

            assertEquals("Hotel updated successfully", result.getMessage());
            assertEquals(EntityResult.OPERATION_SUCCESSFUL_SHOW_MESSAGE, result.getCode());
        }
    }
}
