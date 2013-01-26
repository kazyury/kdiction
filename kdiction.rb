vr_DIR="vr/" unless vr_DIR
require vr_DIR+'vruby'
require vr_DIR+'vrcontrol'
require "jcode"

$KCODE="s"

class DictForm < VRForm

	def construct
		self.caption = '漢字を検索！'
		move(140,124,500,400)
		addControl(VRStatic,'static1','検索結果',192,8,120,20,1342177280)
		addControl(VRListbox,'listBox1','listBox1',200,32,272,294,1350565889)

		addControl(VRStatic,'static2','辞書に追加',16,32,120,20,1342177280)
		addControl(VRButton,'addPB','追加',16,92,80,25,1342177280)
		addControl(VREdit,'edit2','',16,64,168,24,1342177280)

		addControl(VRStatic,'static3','順番無しで検索',16,160,120,20,1342177280)
		addControl(VREdit,'edit3','',16,192,168,24)
		addControl(VRButton,'search2PB','検索',16,220,80,25,1342177280)

		addControl(VRStatic,'static4','＠とかＸで検索',16,264,120,20,1342177280)
		addControl(VREdit,'edit1','',16,296,168,24,1342177408)
		addControl(VRButton,'searchPB','検索',16,328,80,25,1342177280)

		addControl(VRButton,'howtoPB','使い方',300,328,80,25,1342177280)
		addControl(VRButton,'exitPB','おしまい',388,328,80,25,1342177280)
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
			messageBox ("入力してね。")
		else
			jstr=@edit1.caption
			regObj=translate(jstr)
			@dict.each{|str|
				@searchResult.push str.chomp if str.chomp=~regObj
			}
			if @searchResult==[]
				messageBox("一致する単語はありません。")
				return
			end
			@listBox1.setListStrings @searchResult
		end
	end

	def search2PB_clicked
		@searchResult=[]
		@listBox1.clearStrings
		if @edit3.caption==""
			messageBox ("入力してね。")
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
				messageBox("一致する単語はありません。")
				return
			end
			@listBox1.setListStrings @searchResult
		end
	end


	def addPB_clicked
		if @edit2.caption==""
		then
			messageBox("入力してね")
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
１．順番無しで検索
　入力した漢字を全て含む単語を検索します。順番は関係無し

	例．'佐土'と入力
	　⇒'土佐犬'とか。

２．＠とかＸ（エックスの大文字）で検索
　Ｘは任意の１漢字を、＠同士は同じ漢字となる単語を検索します。
　順番と文字数は考慮されます。
　（＠やＸは全角でね。）

	例．'＠上＠Ｘ'と入力
	　⇒'天上天下'とか、
	　　'一上一下'とか。
		EOT
	end


	def translate(str)
=begin
	"佐々木ＸＸ"--->/^佐々木..\z/
	"佐々木＠＠"--->/^佐々木(.)\1\z/
	"佐々＠＠＠"--->/^佐々(.)\1\1\z/
=end
		if str=~/Ｘ/
			str.gsub!("Ｘ",".")
		end
		if str=~/＠/
			str.sub!("＠","(.)")
			str=str.gsub("＠",'\\\1')
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
