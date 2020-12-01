import { mount, shallowMount } from '@vue/test-utils';
import LabelList from '@/label-list';
import LabelItem from '@/label-item';

describe('Label Item Component', () => {
  const wrapper = mount(LabelItem, {
    propsData: {
      labelItem: {
        title: "ラベルテスト",
        color: '#ff11bb'
      }
    }
  });

  it("ラベルタイトルとカラーの値がpropsで渡ってくる", () => {
    expect(wrapper.props().labelItem.title).toBe('ラベルテスト');
    expect(wrapper.props().labelItem.color).toBe('#ff11bb');
  });
});