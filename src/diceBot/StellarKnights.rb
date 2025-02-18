# -*- coding: utf-8 -*-

class StellarKnights < DiceBot

  # ダイスボットで使用するコマンドを配列で列挙する
  setPrefixes(['TT', 'STA', 'STB', 'STB2', 'STC', 'ALLS','PRF','HOPE','DESP','STORYA','STORYB','WISH','MAKEA','MAKEB','WAR','FLOWER'])
  
  def initialize
    super
    
    @d66Type = 1
  end
  
  def gameName
    '銀剣のステラナイツ'
  end
  
  def gameType
    "StellarKnights"
  end
  
  def getHelpMessage
    return <<MESSAGETEXT
TT：お題表
STA ：シチュエーション表A：時間
STB ：シチュエーション表B：場所
STB2：シチュエーション表B その2：学園編
STC ：シチュエーション表C：話題
ALLS ：シチュエーション表全てを一括で（学園編除く）
--------------追加ダイスボット--------------
PRF   ：性格表
HOPE  ：希望表
DESP  ：絶望表
STORYA：あなたの物語表
STORYB：あなたの物語表(異世界)
WISH  ：願い表
FLOWER：花章表
MAKEA ：ダイス一括振り(STORYA使用)
MAKEB ：ダイス一括振り(STORYB使用)
--------------追加シチュエーション表--------------
WAR   ：血と硝煙のステラナイツ
MESSAGETEXT
  end
  
  
  def rollDiceCommand(command)
    command = command.upcase
    
    return analyzeDiceCommandResultMethod(command)
  end
  
  
  def getThemeTableDiceCommandResult(command)
    
    return unless command == "TT"
    
    tableName = "お題表"
    table = %w{
未来 占い 遠雷 恋心 歯磨き 鏡
過去 キス ささやき声 黒い感情 だっこ 青空
童話 決意 風の音 愛情 寝顔 鎖
ふたりの秘密 アクシデント！ 小鳥の鳴き声 笑顔 食事 宝石
思い出 うとうと 鼓動 嫉妬 ベッド 泥
恋の話 デート ため息 内緒話 お風呂 小さな傷
}
    
    text, index = get_table_by_d66(table)
    
    result = "#{tableName}(#{index}) ＞ #{text}"
    return result
  end
  
  
  def getSituationTableDiceCommandResult(command)
    
    return unless command == "STA"
    
    tableName = "シチュエーション表A：時間"
    table = %w{
朝、誰もいない
騒がしい昼間の
寂しい夕暮れの横たわる
星の瞬く夜、
静謐の夜更けに包まれた
夜明け前の
}
    text, index = get_table_by_1d6(table)
    
    result = "#{tableName}(#{index}) ＞ #{text}"
    return result
  end
  

  def getPlageTableDiceCommandResult(command)
    
    return unless command == "STB"

    tableName = "シチュエーション表B：場所"
    
    table_1_2 = [
"教室 　小道具：窓、机、筆記用具、チョークと黒板、窓の外から聞こえる部活動の声",
"カフェテラス　小道具：珈琲、紅茶、お砂糖とミルク、こちらに手を振っている学友",
"学園の中庭　小道具：花壇、鳥籠めいたエクステリア、微かに聴こえる鳥の囁き",
"音楽室　小道具：楽器、楽譜、足踏みオルガン、壁に掛けられた音楽家の肖像画",
"図書館　小道具：高い天井、天井に迫る程の本棚、無数に収められた本",
"渡り廊下　小道具：空に届きそうな高さ、遠くに別の学園が見える、隣を飛び過ぎて行く鳥",
                ]
    
    table_3_4 = [
"花の咲き誇る温室　小道具：むせ返るような花の香り、咲き誇る花々、ガラス越しの陽光",
"アンティークショップ　小道具：アクセサリーから置物まで、見慣れない古い機械は地球時代のもの？",
"ショッピングモール　小道具：西欧の街並みを思わせるショッピングモール、衣類に食事、お茶屋さんも",
"モノレール　小道具：車窓から覗くアーセルトレイの街並み、乗客はあなたたちだけ",
"遊歩道　小道具：等間隔に並ぶ街路樹、レンガ造りの街並み、微かに小鳥のさえずり",
"おしゃれなレストラン　小道具：おいしいごはん、おしゃれな雰囲気、ゆったりと流れる時間",
                ]
    table_5_6 = [
"何処ともしれない暗がり　小道具：薄暗がりの中、微かに見えるのは互いの表情くらい",
"寂れた喫茶店　小道具：姿を見せないマスター、その孫娘が持ってくる珈琲、静かなひととき",
"階段の下、秘密のお茶会　小道具：知る人ぞ知る階段下スペースのお茶会、今日はあなたたちだけ",
"学生寮の廊下　小道具：滅多に人とすれ違わない学生寮の廊下、窓の外には中庭が見える",
"ふたりの部屋　小道具：パートナーと共に暮らすあなたの部屋、内装や小物はお気に召すまま",
"願いの決闘場　小道具：決闘の場、ステラナイトたちの花章が咲き誇る場所",
                ]
    
    table = [table_1_2, table_1_2,
             table_3_4, table_3_4,
             table_5_6, table_5_6,].flatten
    
    text, index = get_table_by_d66(table)
    
    result = "#{tableName}(#{index}) ＞ #{text}"
    return result
  end


  def getSchoolTableDiceCommandResult(command)
    
    return unless command == "STB2"
    
    tables =
      [
       { :tableName => "アーセルトレイ公立大学",
         :table => %w{
地下のだだっぴろい学食
パンの種類が豊富な購買の前
本当は進入禁止の屋上
キャンプ部が手入れしている中庭
共用の広いグラウンド
使い古された教室
}},
       
       { :tableName => "イデアグロリア芸術総合大学",
         :table => %w{
（美術ｏｒ音楽）準備室
美しく整備された中庭
音楽室
格調高いカフェテラス
誰もいない大型劇場
完璧な調和を感じる温室
}},
       
       { :tableName => "シトラ女学院",
       :table => %w{
中庭の神殿めいた温室
質素だが美しい会食室
天井まで届く本棚の並ぶ図書館
誰もいない学習室
寮生たちの秘密のお茶会室
寮の廊下
}},
       
       { :tableName => "フィロソフィア大学",
         :table => %w{
遠く聞こえる爆発音
学生のアンケート調査を受ける
空から降ってくるドローン
膨大な蔵書を備えた閉架書庫
鳴らすと留年するという小さな鐘の前
木漏れ日のあたたかな森
}},
              
       { :tableName => "聖アージェティア学園",
       :table => %w{
おしゃれなカフェテラス
小さなプラネタリウム
ローマの神殿めいた屋内プール
誰もいない講堂
謎のおしゃれな空き部屋
花々の咲き乱れる温室
}},
       
     { :tableName => "スポーン・オブ・アーセルトレイ",
       :table => %w{
人気のない教室
歴代の寄せ書きの刻まれた校門前
珍しく人気のない学食
鍵の外れっぱなしの屋上
校舎裏
 外周環状道路へ繋がる橋
}},
             ]
    
    result = ''
    
    tables.each_with_index do |table, i|
      tableName = table[:tableName]
      table = table[:table]
      
      text, index = get_table_by_1d6(table)
      
      result << "\n" unless i == 0 
      result << "#{tableName}(#{index}) ＞ #{text}"
    end
    
    return result
  end
  
  
  def getTpicTableDiceCommandResult(command)
    
    return unless command == "STC"

    tableName = "シチュエーション表C：話題"
    
    table_1_3 = [
"未来の話：決闘を勝ち抜いたら、あるいは負けてしまったら……未来のふたりはどうなるのだろう。",
"衣服の話：冴えない服を着たりしていないか？　あるいはハイセンス過ぎたりしないだろうか。よぉし、私が選んであげよう!!",
"ステラバトルの話：世界の未来は私たちにかかっている。頭では分かっていても、まだ感情が追いつかないな……。",
"おいしいごはんの話：おいしいごはんは正義。１００年前も６４０５年前も異世界だろうと、きっと変わらない真理なのだ。おかわり！",
"家族の話：生徒たちは寮生活が多い。離れて暮らす家族は、どんな人たちなのか。いつかご挨拶に行きたいと言い出したりしても良いだろう。",
"次の週末の話：週末、何をしますか？　願いをかけた決闘の合間、日常のひとときも、きっと大切な時間に違いない。",
                ]
    
    table_4_6 = [
"好きな人の話：……好きな人、いるんですか？　これはきっと真剣な話。他の何よりも重要な話だ。",
"子供の頃の話：ちいさな頃、パートナーはどんな子供だったのだろうか。どんな遊びをしたのだろうか。",
"好きなタイプの話：パートナーはどんな人が好みなのでしょうか……。気になります、えぇ。",
"思い出話：ふたりの思い出、あるいは出会う前の思い出の話。",
"願いの話：叶えたい願いがあるからこそ、ふたりは出会った。この戦いに勝利したら、どんな形で願いを叶えるのだろうか。",
"ねぇ、あの子誰？：この前見かけたパートナーと一緒にいた子。あの子誰？だーれー!?　むー!!"
                ]
    
    table = [table_1_3, table_1_3, table_1_3, 
             table_4_6, table_4_6, table_4_6, ].flatten
    
    text, index = get_table_by_d66(table)
    
    result = "#{tableName}(#{index}) ＞ #{text}"
    return result
  end
  
  
  def getAllSituationTableDiceCommandResult(command)
    
    return unless command == "ALLS"
    
    commands = ['STA', 'STB', 'STC']
    
    result = ""
    
    commands.each_with_index do |command, i|
      result << "\n" unless i == 0
      result << analyzeDiceCommandResultMethod(command)
    end
    
    return result
  end
  
    def getPRF100TableDiceCommandResult(command)
    
    return unless command == "PRF100"

    tableName = "希望表"
    
    table = [
"可憐",
"冷静",
"勇敢",
"楽観主義",
"負けず嫌い",
"コレクター気質",
"クール",
"癒し系",
"惚れやすい",
"悲観主義",
"泣きやすい",
"お嬢様",
"純粋",
"頑固",
"辛辣",
"まじめ",
"落ち込みやすい",
"謙虚",
"スマート",
"ゆるふわ",
"好奇心旺盛",
"はらぺこ",
"華麗",
"狭い所が好き",
"冷徹",
"朴念仁",
"王子様",
"目立ちたがり",
"過激",
"マゾヒスト",
"ダンディ",
"あらあらうふふ",
"過保護",
"死にたがり",
"強い自尊心",
"サディスト",
"天然",
"無関心",
"感情を表に出さない",
"オタク",
"素直",
"屁理屈",
"お姫様",
"サイコパス",
"昼行灯",
"無邪気",
"お坊ちゃま",
"ナルシスト",
"研究者気質",
"キュート",
"ジャンキー",
"まったり",
"ふええ",
"残忍",
"姐御",
"嘘つき",
"筋肉信者",
"病弱",
"地味",
"エレガント",
"冷酷",
"漢気溢れる",
"甘党",
"情熱的",
"グルメ",
"家庭的",
"辛党",
"寂しがり屋",
"アクティブ",
"強がり",
"カッコつけ",
"妖艶",
"乙女",
"挙動不審",
"まったり",
"怖がり",
"意地っ張り",
"天使",
"死神",
"皮肉屋",
"博打好き",
"モテやすい",
"社畜",
"チャラい",
"女嫌い",
"男嫌い",
"ハッピー",
"影が薄い",
"リーダー気質",
"甘えた",
"お母さん",
"照れ屋",
"能天気",
"お兄ちゃん",
"しっかり者",
"着の身着のまま",
"ツンデレ",
"潔癖症",
"個性的",
"多重人格",
                ]
  
    ftext,  =  get_table_by_nDx(table,1,100)
    stext,  =  get_table_by_nDx(table,1,100)
  
    result = "\n性格表＞#{ftext}にして#{stext}"
    return result
  end

  def getProfileDiceCommandResult(command)
  
  return unless command == "PRF"
  
  tableName = "性格表"
    table = %w{
可憐 冷静 勇敢 楽観主義 負けず嫌い コレクター気質
クール 癒し系 惚れやすい 悲観主義 泣きやすい お嬢様
純粋 頑固 辛辣 まじめ 落ち込みやすい 謙虚
スマート ゆるふわ 好奇心旺盛 はらぺこ 華麗 狭い所が好き
冷徹 朴念仁 王子様 目立ちたがり 過激 マゾヒスト
ダンディ あらあらうふふ 過保護 死にたがり 強い自尊心 サディスト
}
  
  ftext,  = get_table_by_d66(table)
  stext,  = get_table_by_d66(table)
  
  result = "\n性格表＞#{ftext}にして#{stext}"
  return result
  
  end

  def getHopeTableDiceCommandResult(command)
    
    return unless command == "HOPE"

    tableName = "希望表"
    
    table_1_3 = [
"より良き世界：世界はもっと素敵になる。きっと、ずっと、もっと。",
"まだ物足りない：もっと上へ、もっと強く、あなたの未来は輝いてる。",
"立ち止まってる暇はない！：止まっている時間がもったいない。もっともっと世界を駆けるのだ！",
"私が守るよ：君を傷つける全てから、私が絶対守ってあげる。",
"未来は希望に満ちている：生きていないと、素敵なことは起きないんだ！",
"慈愛の手：届く限り、あなたは手を差し伸べ続ける。",
                ]
    
    table_4_6 = [
"自分を犠牲にしてでも：世界はもっとキラキラしているんだよ。それを伝える為に、あなたは自分を犠牲にする",
"右手を伸ばす：救いたい物、助けたいもの、大事なもの、何一つ見捨てるつもりはない！",
"無限の愛：愛を注ごう。この胸に溢れんばかりの愛を！",
"あなたを王に：絶望を知ったパートナーこそ、世界の王にふさわしい。私があなたを王にする！",
"救世主：私はきっと、世界を救える。誰だって、救ってみせる。",
"大好きな人のために：世界は希望に満ちている。あなたをもっと幸せにしたいの！",
                ]
    
    table = [table_1_3, table_1_3, table_1_3, 
             table_4_6, table_4_6, table_4_6, ].flatten
    
    text, index = get_table_by_d66(table)
    
    result = "\n#{tableName}(#{index}) ＞ #{text}"
    return result
  end

  def getUNHopeTableDiceCommandResult(command)
    
    return unless command == "DESP"

    tableName = "絶望表"
    
    table_1_3 = [
"理不尽なる世界:あなたは世界がいかに理不尽であるか思い知った。",
"この手は届かない:あなたにも目標はあった。しかし、",
"停滞した世界:どんなにあがこうと、世界は変わらない。この絶望は救われない。",
"どうして僕をいじめるの:あなたは虐げられてきた。守ってくれるものなど、どこにも居なかった。",
"過去は絶望に満ちている:ずっとずっと、悪いことばかり。辛いことばかりだった。",
"周囲の視線:世界があなたを見る目は、限りなく冷たいものだった。",
                ]
    
    table_4_6 = [
"大事故:それは壮絶な事故、いいや、それは事故なんて優しいものですらなかった。",
"目の前で消えたモノ:あなたの目の前で大切なものは消えてしまった。",
"喪失:何より大事にしてたものは、もう二度と、この手には戻らない。",
"没落:あなたか、あなたの親か、ともかくあなたはかつての栄光を一瞬にして失った。",
"救いはない:底の底へと沈んでしまった。もう、誰も、私を救ってくれる人は…。",
"偽物だった:あなたは幸せだった。そう思っていた。でもそれはすべて作り物で、あなたは騙されていたのだ。",
                ]
    
    table = [table_1_3, table_1_3, table_1_3, 
             table_4_6, table_4_6, table_4_6, ].flatten
    
    text, index = get_table_by_d66(table)
    
    result = "\n#{tableName}(#{index}) ＞ #{text}"
    return result
  end
  
  def getStoryTableDiceCommandResult(command)
    
    return unless command == "STORYA"

    tableName = "あなたの物語表"
    
    table_1_2 = [
"熟練ステラナイト:あなたは既に何度もステラバトルを征してきた熟練者である。【勲章: 3~7の間の好きな値】 【歪みの共鳴: 1】",
"権力者の血筋:統治政府や企業の上層部、あるいは学園組織の運営者の家系である。",
"天才:あなたは紛うことなき天才だ。",
"天涯孤独:あなたに両親はいない。促成培養槽で造られた者なのか、あるいは両親を失ったのか",
"救いの手:あなたは誰かに助けてもらった。だから、ここにいるのだ。",
"欠損:心や身体、大切な宝物、家族、あなたは何かを失って、そのまま今に至った。",
                ]
    
    table_3_4 = [
"大切なもの:大事にしているものがある。",
"お気に入りの場所:好きな場所がある。秘密の場所、あるいは誰かと来たい場所。",
"メイドorバトラー:あなたには仕えるべき相手がいる。金銭の関係か、家柄か、恩義故かは自由に決めて良い。",
"パートナー大好き！！！！！！:私はー！！パートナーがー！！大好きだー！！！",
"目指せ理想のタイプ:パートナーの理想のタイプ目指してー、ファイトー!!",
"世界への不満:こんな世界はダメダメだ! 私が絶対に創り変えてやる!!",
                ]

    table_5_6 = [
"停滞:何もかもがつまらない。満たされない。動かない世界に嫌気が差している。",
"願いの奴隷:願いを叶える為なら、手段は選ばない。願いの為だけに私は生きている。",
"犯罪者の子:あなたの親は何らかの犯罪に手を染めた。その悪評は、子である君にも影響を及ぼしている。",
"探求者:世界の真実、隠された真実、万物の真理 あなたが追い求めるものはどこまでも尽きない。",
"正義:困った人を見捨てられない、悪は許せない、この胸に宿るのは正義の心。",
"誓約生徒会(カヴェナンター):あなたは一度、エクリプスと化し、討伐された者だ。しかし願いを諦めることは出来ない。だから、あなたはこの仮面を受け取り、戦い続けているのだ。【勲章:0~5の間の好きな値】【歪みの共鳴: 0~2の間の好きな値】",
                ]
    
    table = [table_1_2, table_1_2, table_3_4, 
             table_3_4, table_5_6, table_5_6, ].flatten
    
    text, index = get_table_by_d66(table)
    
    result = "\n#{tableName}(#{index}) ＞ #{text}"
    return result
  end
  
  def getAnotherStoryTableDiceCommandResult(command)
    
    return unless command == "STORYB"

    tableName = "あなたの物語表(異世界)"
    
    table_1_2 = [
"終わりなき戦場:あなたは果ての見えない戦場の世界からここへ流れ着いた。",
"滅びの世界:戦争、あるいは環境汚染か、滅びた後の世界からここへ流れ着いた。",
"獣人たちの世界:人とは、獣の特徴を備えた者を指す言葉だった――あなたの世界では。あなたは獣の特徴を備えており、それはアーセルトレイでは奇異の目で見られることだろう。",
"箱庭の世界:都市か、屋敷か、あなたの住んでいた世界は極狭いものだった。大好きな姉妹や家族と、ただ平穏に暮らすだけの日々。永遠に続くと思っていたそれは、ある日突然に崩壊して、あなたはこの世界へと辿りついた。",
"永遠なる迷宮の世界:無限に広がる迷宮の世界、人々はそこを旅する探索者だった。旧世界の遺産とも称される星まるごとが迷宮の世界、心躍る冒険。そんな日々は、ある日突然に終わってしまった。あなたが辿り着いたのは、アーセルトレイと呼ばれるこの場所だった。",
"巡礼者の世界:広大な自然と石造りの都の世界を、誰もが旅をし続ける世界からあなたはここへ流れ着いた。アーセルトレイに存在する文明は、どれもあなたにとって未知のものだろう。だが、広大なるあの世界へ、戻ることはもう出来ないのだ。",
                ]
    
    table_3_4 = [
"永遠のヴィクトリア: 200年にわたるヴィクトリア女王の統治が続く常闇の世界。蒸気の霧が街を覆い、夜な夜な怪人が闊歩する世界から、 あなたはここへ流れ着いた。あなたからすれば、ここは平和な世界だ。しかし、ステラバトルの願いがぶつかる華やかさだけは、あの頃を思い出させる。",
"剣撃乱舞する世界:我々からすれば戦国と呼ばれた極東の一時代を繰り返していた世界からあなたはここへ流れ着いた。あなたの剣技はステラバトルを切り抜けるのに十分に役立つことだろう。",
"薄暗き森の世界:広大にして永遠に続く森に包まれた世界、霧と風、獣の鳴き声に満ちた世界から、あなたはここへ流れ着いた。あなたの姿を見て、エルフだとか、妖精だとか呼ぶものもいるかもしれないが、あなたには関係のないことだ。",
"人類の瀬戸際:ここも、故郷も、大して変わらない。あなたの故郷は、地球に先んじてロアテラに滅ぼされた世界だ。ここを守護することに躊躇いはない。しかしそれよりも、あなたにとってはここで出会った唯一のパートナーの方が大切なのだ。",
"人形劇の世界:あなたの世界に生きる人々は、元々は人間と呼ばれていたらしい。全ての住人が人形と化したあなたの故郷は、それなりに平和で、楽しいものだったはずだ。しかしそんな日々は、ある日突然終わってしまった。人形そのものであるあなたの姿は、時に奇異の目で見られることだろう。",
"怪獣迎撃の世界:巨大な怪獣が存在し、それを迎え撃つ戦いを繰り返していた世界から、あなたはここへ流れ着いた。そして今も、アーセルトレイは異世界からの侵略者、ロアテラに狙われていると、あなたは理解している。",
                ]

    table_5_6 = [
"蒸気機関の世界:蒸気機関技術が異様に発達した世界から、あなたはここへ流れ着いた。アーセルトレイの技術レベルはそれらに匹敵するものだが、あなたからすると使い方の分からない不思議な技術だ。",
"極東幻想の世界:我々の知る旧地球時代の日本、その国にて語られた鬼や妖怪が実在した世界からあなたはここへ流れ着いた。あなたからすれば、ステラナイトの強さはそれらをも超えるものかもしれない。",
"異端生物の世界:パイオ技術か、交配の結果か、様々な生物と人類が融合した世界から、あなたはここへ辿り着いた。獣や鳥、海棲生物の特徴をあなたは備えている。",
"異端科学の世界:人と機械の境界が曖昧な世界、個と全が曖昧な世界から、あなたはここへ流れ着いた。",
"先進科学の世界:地球の科学がどこまでも真っ直ぐに育った世界から、あなたはここへ流れ着いた。美しく磨きあげられた街並み、道行く人の誰もが笑顔で、万人が幸せな世界から。",
"草花の世界:植物と人が融合した世界から、あなたはここへ流れ着いた。あなたの身体は植物そのものかもしれないし、あるいは眼窩から花が咲いているかもしれない。",
                ]
    
    table = [table_1_2, table_1_2, table_3_4, 
             table_3_4, table_5_6, table_5_6, ].flatten
    
    text, index = get_table_by_d66(table)
    
    result = "\n#{tableName}(#{index}) ＞ #{text}"
    return result
  end
  
  def getWishTableDiceCommandResult(command)
    
    return unless command == "WISH"

    tableName = "願い表"
    
    table_1_2 = [
"未知の開拓者:誰も知らない世界、誰も知らない宇宙、誰も知らない星に旅立つんだ! 【願いの階梯:4]",
"故郷の復興:あなたの故郷である異世界、あるいは地球を復興する。【願いの階梯:4 (階層規模の場合)】【願いの階梯:7 (惑星規模の場合)】",
"復讐:絶対にこの復讐を果たすのだ。【願いの階梯:2】",
"誰にも傷つけられない世界:誰も私たちを傷つけない。そんな世界であればいい。【願いの階梯:7 (惑星規模)】【願いの階梯:8 (宇宙規模)】",
"きらめく世界:世界を明るく楽しくしたい。私が光になるんだ! 【願いの階梯:3 (自分の変革)】【願いの階梯:7 (世界そのものの変革)】",
"おいしいごはん:ふたりで美味しいご飯を食べよう。それが世界で、一番大切なことなんだよ!【願いの階梯:2(おいしいごはんを食べるだけ)】【願いの階梯:4 (ふたりの置かれた状況の改善)】",
                ]
    
    table_3_4 = [
"私だけのもの:独り占めしたいモノがある。【願いの階梯:5】",
"新たなる存在:この世に存在しないけれど、存在してほしいと願うモノ。私はそれが欲しいんだ。【願いの階梯:6】",
"欲しいもの:どうしても手に入れたいものがある。【願いの階梯:1~10(欲しいものの種類によって変動)】",
"取り戻す:あなたたちは何かを奪われた。それを取り戻すのが、唯一の願いだ。【願いの階梯:4(努力次第でいつか手に届く範囲)】【願いの階梯:6 (通常は取り戻せないもの)】",
"誰よりも、高く、遠くへ!:こんな鳥籠は嫌だ。空の果てを目指すんだ!【願いの階梯:4(努力次第でいつか叶う範囲)】【願いの階梯:8(宇宙規模の場合)】",
"あなたを自由に:大切なものは囚われ、縛られている。私のちからで、それを解き放つんだ!【願いの階梯:4(努力次第でいつか叶う範囲)】【願いの階梯:6(奇跡の領域)】",
                ]

    table_5_6 = [
"誰かの笑顔:誰かの笑顔の為に戦っても、いいだろう?【願いの階梯:1～6 (対象の状況によって変動する)】",
"別の世界へ:……この世界ではない、別の世界へ行きたい。【願いの階梯:7(惑星規模)】【願いの階梯:8(宇宙規模)】",
"世界を平和に:平穏な日々を願っても許されるような世界に、この世界をやすらぎに満ちた場所に....。【願いの階梯:7】",
"世界を再誕させる:世界は根本から創り直す必要がある!【願いの階梯:8】",
"世界を征服する:私たちが王になってやる! 【願いの階梯:7】",
"契約者:あなたの願いは既に叶えられた。今も戦い続けている理由は女神との契約があるからだ。【願いの階梯:なし】",
                ]
    
    table = [table_1_2, table_1_2, table_3_4, 
             table_3_4, table_5_6, table_5_6, ].flatten
    
    text, index = get_table_by_d66(table)
    
    result = "\n#{tableName}(#{index}) ＞ #{text}"
    return result
  end
  
  def getMAKEATableDiceCommandResult(command)
    
    return unless command == "MAKEA"
    
    commands = ['STORYA', 'HOPE', 'DESP','WISH','PRF']
    
    result = ""
    
    commands.each_with_index do |command, i|
      result << "\n" unless i == 0
      result << analyzeDiceCommandResultMethod(command)
    end
    
    return result
  end

  def getMAKEBTableDiceCommandResult(command)
    
    return unless command == "MAKEB"
    
    commands = ['STORYB', 'HOPE', 'DESP','WISH','PRF']
    
    result = ""
    
    commands.each_with_index do |command, i|
      result << "\n" unless i == 0
      result << analyzeDiceCommandResultMethod(command)
    end
    
    return result
  end

  def getWARTableDiceCommandResult(command)
    
    return unless command == "WAR"

    tableName = "血と硝煙のシチュエーション表"
    
    table_1_3 = [
"「この戦線は敗北だ、離脱しろ」撤退命令だ。この戦線での戦闘は敗北だ。",
"「こちら分隊、救難を求む」救難信号だ。近くに居るのは自分達だけのようだが……",
"「作戦コード００ミッションを達成せよ」単独任務だ。頼れるのは相棒だけ。",
"「戦線が移動する、あんたらもそちらへ移ってくれ」戦線は移り変わる。そこに規則性なんてない。",
"「ーーーー」銃声、悲鳴、そして、無線は途絶えた。",
"「急の任務だ」新たな任務が追加される。作戦のためなら仕方ない。",
                ]
    
    table_4_6 = [
"「今回の任務は……」新たな任務の為のミーティング。これも、必要なことだ。",
"「支給品だ」補給も戦場においては大事なものだ。美味い不味いはさておき。",
"「作戦は1時間後、しっかり用意しておけ」戦場に赴く為に必要な準備。怠ればそれは死へと繋がる。",
"「黙祷」死した仲間へ捧げる暫しの時間。願わくは次がないように。",
"「生きて帰ってくるのを祈ってるぞ」戦場の只中、貴方はそこに投下される。貴方の動きで戦況が動く。",
"Dレーションを手に入れた！やばいやつだ！やったー！(演出で食べた場合、ステラバトルの時にアタック判定のダイスを任意のタイミングで１つ増やしていい)",
                ]
    
    table = [table_1_3, table_1_3, table_1_3, 
             table_4_6, table_4_6, table_4_6, ].flatten
    
    text, index = get_table_by_d66(table)
    
    result = "\n#{tableName}(#{index}) ＞ #{text}"
    return result
  end

  def getFLOWERTableDiceCommandResult(command)
    
    return unless command == "FLOWER"
    
    table_flo = [
"バラ",
"オダマキ",
"コスモス",
"ヒルガオ",
"アネモネ",
"ヒガンバナ",
"アマランサス",
                ]
    
    table_col = [
"黒",
"赤",
"黃",
"青",
"白",
"紫",
                ]
   
    
    resultf,number1  = get_table_by_nDx(table_flo, 1, 7)
    resultc,number2  = get_table_by_nDx(table_col, 1, 6)

    result = "\n花章表 ＞ #{resultc}の#{resultf}"
    return result

  end




end
