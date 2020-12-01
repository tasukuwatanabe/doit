import { mount } from '@vue/test-utils';
import LabelModal from '@/label-modal'

describe('Label List Component', () => {
  const wrapper = mount(LabelModal);
  wrapper.setData({ modalActive: true });

  it("ラベルタイトルが入力できる", () => {
    const input = 'input[type="text"]';
    const textInput = wrapper.find(input);
    textInput.setValue('ラベルテスト');

    expect(wrapper.find(input).element.value).toBe('ラベルテスト');
  });
});