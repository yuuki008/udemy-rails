require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #new' do
    before { get :new }
    it 'レスポンスコードが200であること' do
      expect(response).to have_http_status(:ok)
    end
    it 'newテンプレートをレンダリングすること' do
      expect(response).to render_template :new
    end
    it '新しいuserオブジェクトがビューに渡される' do
      expect(assigns(:user)).to be_a_new User
    end
  end

  describe "POST #create" do
    context '正しいユーザー情報が渡ってきた場合' do
      let(:params) do
        { user: {
            name: 'user',
            password: 'password',
            password_confirmation: 'password'
          }
        }
      end
      it 'ユーザーが一人増えていること' do
        expect {post :create, params: params}.to change(User, :count).by(1)
      end

      it 'マイページにリダイレクトされること' do
        expect(post :create, params: params).to redirect_to(mypage_path)
      end
    end
    context "パラメータに正しいユーザー名、確認パスワードが福間わていない場合" do
      before do
        post(:create, params: {
          user:{
            name: 'ユーザー1',
            password: 'password',
            password_confirmation: 'invalid_password'
          }
        })
      end
      it 'リファラーにリダイレクトされること' do
        expect(response).to redirect_to new_user_path
      end

      it 'ユーザー名のエラーメッセージが含まれていること' do
        expect(flash[:error_messages]).to include 'ユーザー名は小文字英数字で入力してください'
      end

      it 'パスワード確認のエラーメッセージが含まれていること' do
        expect(flash[:error_messages]).to include 'パスワード(確認)とパスワードの入力が一致しません'
      end
    end   
  end
end
