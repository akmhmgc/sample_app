module StaticPagesHelper
    # ページごとの完全なタイトルを返します。
    def title_describe(page_title = '')
        # 最終行が出力値であれば、return は必要ない
        return "うんこ#{page_title}ですよ"
    end
end

