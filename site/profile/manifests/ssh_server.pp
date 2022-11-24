class profile::ssh_server {
	package {'openssh-server':
		ensure => present,
	}
	service { 'sshd':
		ensure => 'running',
		enable => 'true',
	}
	ssh_authorized_key { 'root@puppetmaster.vm':
		ensure => present,
		user   => 'root',
		type   => 'ssh-rsa',
		key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABgQDjh8/+5HUb/lt0mne6SJum+PLHavc32S3aLtkHpF/xZ/g5K67jbd0s7gsHRckW3LLq9FAHVAAwZdKXG1OjurNfFuXjV6O0pQq/SSnOSftrEZdU3PbvaqlpEZQAqhDsMq9QPsLYfsqo1n/XQ93GVOit/P9v/khw+yPHi6EYNcHdNJK9/8a3DTnc60sHB5sDb3GNaJzuaX/2WAwc7W/4A2Rw1W6Ko6ZN2WOdvqHzX02x2i9v1O+IYUGEbzB776SV4nAIWAyUAUhUWvhqvvrhv55sQSbTYue8O8qcCVjBTCfVmjXShXFIRF7MAzUP+hBOGTHaRgq7lkoiPf8KtzCOe7HoZUf31mbFHNONsoLDXmFV6g0iOX4CUncjn8O8oYqThBNSiTCAeVwKr4wiyUOg272hm+txCSF2LOFWbnCXiAHQK6w6bHPdp4f/74IQxOZMOgycHtM40p4se5g3tpRWvhl9OcPw3DDgtZbLQtVT0LuEucy9CxbxuAZ6mmUHVLT1vBk=',
	}
}
