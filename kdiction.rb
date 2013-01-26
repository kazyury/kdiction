vr_DIR="vr/" unless vr_DIR
require vr_DIR+'vruby'
require vr_DIR+'vrcontrol'
require "jcode"

$KCODE="s"

class DictForm < VRForm

	def construct
		self.caption = '�����������I'
		move(140,124,500,400)
		addControl(VRStatic,'static1','��������',192,8,120,20,1342177280)
		addControl(VRListbox,'listBox1','listBox1',200,32,272,294,1350565889)

		addControl(VRStatic,'static2','�����ɒǉ�',16,32,120,20,1342177280)
		addControl(VRButton,'addPB','�ǉ�',16,92,80,25,1342177280)
		addControl(VREdit,'edit2','',16,64,168,24,1342177280)

		addControl(VRStatic,'static3','���Ԗ����Ō���',16,160,120,20,1342177280)
		addControl(VREdit,'edit3','',16,192,168,24)
		addControl(VRButton,'search2PB','����',16,220,80,25,1342177280)

		addControl(VRStatic,'static4','���Ƃ��w�Ō���',16,264,120,20,1342177280)
		addControl(VREdit,'edit1','',16,296,168,24,1342177408)
		addControl(VRButton,'searchPB','����',16,328,80,25,1342177280)

		addControl(VRButton,'howtoPB','�g����',300,328,80,25,1342177280)
		addControl(VRButton,'exitPB','�����܂�',388,328,80,25,1342177280)
		begin
			f=open("dict.txt","r")
			@dict=f.readlines
			f.close
		rescue
			@dict=[]
		end
		@searchResult=[]
	end

	def searchPB_clicked
		@searchResult=[]
		@listBox1.clearStrings
		if @edit1.caption==""
			messageBox ("���͂��ĂˁB")
		else
			jstr=@edit1.caption
			regObj=translate(jstr)
			@dict.each{|str|
				@searchResult.push str.chomp if str.chomp=~regObj
			}
			if @searchResult==[]
				messageBox("��v����P��͂���܂���B")
				return
			end
			@listBox1.setListStrings @searchResult
		end
	end

	def search2PB_clicked
		@searchResult=[]
		@listBox1.clearStrings
		if @edit3.caption==""
			messageBox ("���͂��ĂˁB")
		else
			jstr=@edit3.caption
			@dict.each{|word|
				flag=true
				jstr.each_char{|char|
					if word.include?(char)
						# do nothing
					else
						flag=false
					end
				}
				@searchResult.push word.chomp if flag==true
			}
			if @searchResult==[]
				messageBox("��v����P��͂���܂���B")
				return
			end
			@listBox1.setListStrings @searchResult
		end
	end


	def addPB_clicked
		if @edit2.caption==""
		then
			messageBox("���͂��Ă�")
		else
			@dict.push @edit2.caption
			@edit2.caption=""
		end
	end

	def exitPB_clicked
		@dict.uniq!
		f=open("dict.txt","w")
		@dict.each{|word|
			f.puts word
		}
		f.close
		self.close
	end

	def howtoPB_clicked
		messageBox <<-EOT
�P�D���Ԗ����Ō���
�@���͂���������S�Ċ܂ޒP����������܂��B���Ԃ͊֌W����

	��D'���y'�Ɠ���
	�@��'�y����'�Ƃ��B

�Q�D���Ƃ��w�i�G�b�N�X�̑啶���j�Ō���
�@�w�͔C�ӂ̂P�������A�����m�͓��������ƂȂ�P����������܂��B
�@���Ԃƕ������͍l������܂��B
�@�i����w�͑S�p�łˁB�j

	��D'���し�w'�Ɠ���
	�@��'�V��V��'�Ƃ��A
	�@�@'���ꉺ'�Ƃ��B
		EOT
	end


	def translate(str)
=begin
	"���X�؂w�w"--->/^���X��..\z/
	"���X�؁���"--->/^���X��(.)\1\z/
	"���X������"--->/^���X(.)\1\1\z/
=end
		if str=~/�w/
			str.gsub!("�w",".")
		end
		if str=~/��/
			str.sub!("��","(.)")
			str=str.gsub("��",'\\\1')
		end
		strObj=/^#{str}\z/
		return strObj
	end

	def translate2(str)
		p str.split(/ */).join('|')
	end

end

#frm=VRLocalScreen.newform(nil,WStyle::WS_MAXIMIZE,DictForm)
frm=VRLocalScreen.newform(nil,nil,DictForm)
frm.create.show
VRLocalScreen.messageloop
