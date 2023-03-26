
#include "rclcpp/rclcpp.hpp"
// #include <example_interfaces/srv/add_two_ints.hpp>
#include "tutorial_interfaces/srv/add_three_ints.hpp"

void add(
    std::shared_ptr<tutorial_interfaces::srv::AddThreeInts::Request> const request,
    std::shared_ptr<tutorial_interfaces::srv::AddThreeInts::Response> const response){

    response->sum = request->a + request->b + request->c;

    auto logger{rclcpp::get_logger("rclcpp")};
    RCLCPP_INFO(logger, "incoming request\na: %ld b: %ld", request->a, request->b);
    RCLCPP_INFO(logger, "sending back response: [%ld]", (long int)response->sum);
}

int main(int argc, char* argv[]){
    rclcpp::init(argc, argv);
    auto node = rclcpp::Node::make_shared("add_three_ints_server");
    rclcpp::Service<tutorial_interfaces::srv::AddThreeInts>::SharedPtr service = node->create_service<tutorial_interfaces::srv::AddThreeInts>("add_three_ints", &add);

    auto logger{rclcpp::get_logger("rclcpp")};
    RCLCPP_INFO(logger, "Ready to add three ints.");

    rclcpp::spin(node);
    rclcpp::shutdown();
    return 0;
}
