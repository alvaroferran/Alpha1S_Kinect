#!/usr/bin/env python

import rospy
from alpha1s import Alpha1S
from std_msgs.msg import Int16MultiArray


def send_pose(data, robot):
    rospy.loginfo("Received: %s", data.data)
    angles = data.data
    robot.servo_write_all(angles)


def listener():
    robot = Alpha1S()
    print("Done")
    rospy.init_node('alpha1s_send', anonymous=True)
    rospy.Subscriber("kinect_angles", Int16MultiArray, send_pose, robot)
    rospy.spin()


if __name__ == '__main__':
    print("Connecting to Alpha1S... ", end="")
    listener()
