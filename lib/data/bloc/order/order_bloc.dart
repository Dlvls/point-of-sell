import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/order_repository.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepository;

  OrderBloc(this.orderRepository) : super(const OrderLoadingState()) {
    on<LoadOrdersEvent>((event, emit) async {
      emit(const OrderLoadingState());
      try {
        final orders = await orderRepository.getOrders();
        print('Orders loaded: $orders'); // Debugging line
        emit(OrderLoadedState(orders));
      } catch (e) {
        print('Error loading orders: $e'); // Debugging line
        emit(OrderErrorState(e.toString()));
      }
    });

    on<AddOrderEvent>((event, emit) async {
      emit(const OrderLoadingState());
      try {
        await orderRepository.addOrder(event.order);
        final orders = await orderRepository.getOrders();
        emit(OrderLoadedState(orders));
      } catch (e) {
        emit(OrderErrorState(e.toString()));
      }
    });

    on<UpdateOrderEvent>((event, emit) async {
      emit(const OrderLoadingState());
      try {
        await orderRepository.updateOrder(event.order);
        final orders = await orderRepository.getOrders();
        emit(OrderLoadedState(orders));
      } catch (e) {
        emit(OrderErrorState(e.toString()));
      }
    });

    on<DeleteOrderEvent>((event, emit) async {
      emit(const OrderLoadingState());
      try {
        await orderRepository.deleteOrder(event.orderId);
        final orders = await orderRepository.getOrders();
        emit(OrderLoadedState(orders));
      } catch (e) {
        emit(OrderErrorState(e.toString()));
      }
    });

    on<FilterOrdersEvent>((event, emit) async {
      emit(const OrderLoadingState());
      try {
        final orders = await orderRepository.getOrders();

        final filteredOrders = orders.where((order) {
          bool matches = true;

          if (event.product != null && event.product!.isNotEmpty) {
            matches =
                order.items.any((item) => item.productId == event.product);
          }

          if (event.dateRange != null) {
            final orderDate = order.orderTime;
            matches &= orderDate.isAfter(event.dateRange!.start) &&
                orderDate.isBefore(event.dateRange!.end);
          }

          if (event.minPrice != null && event.maxPrice != null) {
            matches &= order.totalPrice >= event.minPrice! &&
                order.totalPrice <= event.maxPrice!;
          }

          return matches;
        }).toList();

        emit(OrderLoadedState(filteredOrders));
      } catch (e) {
        emit(OrderErrorState(e.toString()));
      }
    });
  }
}
