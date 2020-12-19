import { mount, shallowMount } from '@vue/test-utils';
import LabelItem from '@/label-item';

describe('Label Item Component', () => {
  const wrapper = mount(LabelItem, {
    propsData: {
      targetItem: {
        label_title: "ラベルテスト",
        label_color: '#ff11bb'
      }
    }
  });

  it("ラベルタイトルとカラーの値がpropsで渡ってくる", () => {
    expect(wrapper.props().targetItem.label_title).toBe('ラベルテスト');
    expect(wrapper.props().targetItem.label_color).toBe('#ff11bb');
  });
});