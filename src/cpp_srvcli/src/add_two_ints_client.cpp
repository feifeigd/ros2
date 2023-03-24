
#include "rclcpp/rclcpp.hpp"
#include <example_interfaces/srv/add_two_ints.hpp>

using namespace std::chrono_literals;

// ros2 run cpp_srvcli client 8 9
int main(int argc, char* argv[]){

    rclcpp::init(argc, argv);
    auto logger{rclcpp::get_logger("rclcpp")};

    if(argc != 3){
        RCLCPP_INFO(logger, "usage: add_two_ints_client X Y");
        return 1;
    }

    auto node = rclcpp::Node::make_shared("add_two_ints_client");
    rclcpp::Client<example_interfaces::srv::AddTwoInts>::SharedPtr client = node->create_client<example_interfaces::srv::AddTwoInts>("add_two_ints");
    auto request = std::make_shared<example_interfaces::srv::AddTwoInts::Request>();
    request->a = atoll(argv[1]);
    request->b = atoll(argv[2]);

    while(!client->wait_for_service(1s)){
        if(!rclcpp::ok()){
            RCLCPP_INFO(logger, "Interrupted while waiting for the service. Exiting.");
            return 0;
        }
        RCLCPP_INFO(logger, "service not available, waiting again...");
    }
    auto result = client->async_send_request(request);
    // Wait for the result.
    if(rclcpp::spin_until_future_complete(node, result) == rclcpp::FutureReturnCode::SUCCESS){
        RCLCPP_INFO(logger, "Sum: %ld", result.get()->sum);
    }else {
        RCLCPP_INFO(logger, "Failed to call service add_two_ints");
    }

    rclcpp::shutdown();
    return 0;
}
