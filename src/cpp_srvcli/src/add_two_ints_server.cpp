
#include "rclcpp/rclcpp.hpp"
#include <example_interfaces/srv/add_two_ints.hpp>

void add(
    std::shared_ptr<example_interfaces::srv::AddTwoInts::Request> const request,
    std::shared_ptr<example_interfaces::srv::AddTwoInts::Response> const response){

    response->sum = request->a + request->b;

    auto logger{rclcpp::get_logger("rclcpp")};
    RCLCPP_INFO(logger, "incoming request\na: %ld b: %ld", request->a, request->b);
    RCLCPP_INFO(logger, "sending back response: [%ld]", (long int)response->sum);
}

int main(int argc, char* argv[]){
    rclcpp::init(argc, argv);
    auto node = rclcpp::Node::make_shared("add_two_ints_server");
    rclcpp::Service<example_interfaces::srv::AddTwoInts>::SharedPtr service = node->create_service<example_interfaces::srv::AddTwoInts>("add_two_ints", &add);

    auto logger{rclcpp::get_logger("rclcpp")};
    RCLCPP_INFO(logger, "Ready to add two ints.");

    rclcpp::spin(node);
    rclcpp::shutdown();
    return 0;
}
