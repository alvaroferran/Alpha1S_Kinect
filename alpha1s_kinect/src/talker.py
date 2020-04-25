#!/usr/bin/env python

import rospy
from std_msgs.msg import Int16MultiArray


def talker():
    pub = rospy.Publisher('kinect_angles', Int16MultiArray, queue_size=10)
    rospy.init_node('talker', anonymous=True)
    rate = rospy.Rate(1)  # Hz
    # Robot poses
    init = [90, 90, 90, 90, 90, 90, 90, 60,
            76, 110, 90, 90, 120, 104, 70, 90]
    hands_up = [90, 180, 90, 90, 0, 90, 90, 60,
                76, 110, 90, 90, 120, 104, 70, 90]
    forward = [0, 0, 90, 180, 180, 90, 90, 60,
               76, 110, 90, 90, 120, 104, 70, 90]
    poses = [init, hands_up, forward]
    pose = 0
    while not rospy.is_shutdown():
        if pose > (len(poses) - 1):
            pose = 0
        data = Int16MultiArray(data=poses[pose])
        pose += 1
        rospy.loginfo(data.data)
        pub.publish(data)
        rate.sleep()


if __name__ == '__main__':
    try:
        talker()
    except rospy.ROSInterruptException:
        pass
